//
//  AAChartViewPluginLoader.swift
//  AAInfographics-ProDemo
//
//  Created by AnAn on 2025/9/28.
//

import WebKit


// --- New Plugin Loader Protocol and Implementations ---

@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
internal protocol AAChartViewPluginLoaderProtocol: AnyObject {
    /// Configures required plugins and consumes `before/afterDrawChartJavaScript`
    /// from options so they can be executed exactly once by the loader.
    func configure(options: AAOptions)

    /// Loads necessary plugins if they haven't been loaded yet.
    func loadPluginsIfNeeded(
        webView: WKWebView,
        userPlugins: Set<String>,
        dependencies: [String: String],
        completion: @escaping () -> Void
    )

    /// Executes the pre-draw JavaScript script.
    func executeBeforeDrawScript(webView: WKWebView)

    /// Executes the post-draw JavaScript script.
    func executeAfterDrawScript(webView: WKWebView)
}

// Default loader for standard version (does nothing)
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
internal final class DefaultPluginLoader: AAChartViewPluginLoaderProtocol {
    public init() {}

    public func configure(options: AAOptions) {
        // No configuration needed for default
    }

    public func loadPluginsIfNeeded(
        webView: WKWebView,
        userPlugins: Set<String>,
        dependencies: [String: String],
        completion: @escaping () -> Void
    ) {
        #if DEBUG
        print("ℹ️ DefaultPluginLoader: No plugins to load.")
        #endif
        completeOnMainThread(completion)
    }

    public func executeBeforeDrawScript(webView: WKWebView) {
        // No pre-draw script for default
    }

    public func executeAfterDrawScript(webView: WKWebView) {
        // No post-draw script for default
    }

    private func completeOnMainThread(_ completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async(execute: completion)
        }
    }
}

// Loader for Pro version, handling plugin loading and scripts
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
internal final class AAChartViewPluginLoader: AAChartViewPluginLoaderProtocol {
    private let pluginProvider: AAChartViewPluginProviderProtocol
    private static let scriptCache: NSCache<NSString, NSString> = {
        let cache = NSCache<NSString, NSString>()
        cache.countLimit = 64
        return cache
    }()
    private let pluginIOQueue = DispatchQueue(label: "com.aa.chartview.pluginloader.io", qos: .utility)
    private var requiredPluginPaths: Set<String> = []
    private var loadedPluginPaths: Set<String> = []
    private var beforeDrawScript: String?
    private var afterDrawScript: String?

    public init(provider: AAChartViewPluginProviderProtocol) {
        self.pluginProvider = provider
    }

    public func configure(options: AAOptions) {
        requiredPluginPaths = pluginProvider.getRequiredPluginPaths(for: options)
        #if DEBUG
        debugLog("🔌 [ProPluginLoader] Determined requiredPluginPaths: \(requiredPluginPaths.map { ($0 as NSString).lastPathComponent })")
        #endif

        // Consume one-shot scripts from options so chart drawing stays idempotent.
        beforeDrawScript = options.beforeDrawChartJavaScript
        options.beforeDrawChartJavaScript = nil

        afterDrawScript = options.afterDrawChartJavaScript
        options.afterDrawChartJavaScript = nil
    }

    public func loadPluginsIfNeeded(
        webView: WKWebView,
        userPlugins: Set<String>,
        dependencies: [String: String],
        completion: @escaping () -> Void
    ) {
        let totalRequiredPluginsSet = requiredPluginPaths.union(userPlugins)
        let pluginsToLoad = totalRequiredPluginsSet.subtracting(loadedPluginPaths)

        guard !pluginsToLoad.isEmpty else {
            #if DEBUG
            if totalRequiredPluginsSet.isEmpty {
                debugLog("ℹ️ [ProPluginLoader] No additional plugins needed.")
            } else {
                debugLog("ℹ️ [ProPluginLoader] All required plugins (count: \(totalRequiredPluginsSet.count)) already loaded.")
            }
            #endif
            completeOnMainThread(completion)
            return
        }

        debugLog("ℹ️ [ProPluginLoader] Preparing to load \(pluginsToLoad.count) new plugin scripts...")
        loadAndEvaluateCombinedPluginScript(
            webView: webView,
            scriptsToLoad: pluginsToLoad,
            dependencies: dependencies
        ) { [weak self] successfullyLoadedPlugins in
            guard let self = self else {
                if Thread.isMainThread {
                    completion()
                } else {
                    DispatchQueue.main.async(execute: completion)
                }
                return
            }
            self.loadedPluginPaths.formUnion(successfullyLoadedPlugins)

            #if DEBUG
            if successfullyLoadedPlugins.count < pluginsToLoad.count {
                print("⚠️ [ProPluginLoader] One or more plugin script files could not be read, or the combined script evaluation failed.")
            } else if !successfullyLoadedPlugins.isEmpty {
                print("✅ [ProPluginLoader] \(successfullyLoadedPlugins.count) new plugin scripts loaded and evaluated successfully.")
            }
            print("ℹ️ [ProPluginLoader] Total loaded plugins count: \(self.loadedPluginPaths.count)")
            #endif
            self.completeOnMainThread(completion)
        }
    }

    public func executeBeforeDrawScript(webView: WKWebView) {
        guard let script = beforeDrawScript else { return }

        debugLog("📝 [ProPluginLoader] Executing BeforeDrawScript...")
        safeEvaluateJavaScriptString(webView: webView, script)
        beforeDrawScript = nil // Execute only once
    }

    public func executeAfterDrawScript(webView: WKWebView) {
        guard let script = afterDrawScript else { return }

        debugLog("📝 [ProPluginLoader] Executing AfterDrawScript...")
        safeEvaluateJavaScriptString(webView: webView, script)
        afterDrawScript = nil // Execute only once
    }

    // --- Helper methods moved from AAChartView ---

    // MARK: - Plugin Dependency Management
    
    /// Configuration for plugin dependencies
    private struct PluginDependencyConfiguration {
        let plugin: AAChartPluginScriptType
        let dependencies: [AAChartPluginScriptType]
        
        init(plugin: AAChartPluginScriptType, dependencies: [AAChartPluginScriptType]) {
            self.plugin = plugin
            self.dependencies = dependencies
        }
    }
    
    /// Centralized plugin dependency configurations
    /// Note: Uses shared PluginScript enum from AAChartViewPluginProvider
    private static let pluginDependencies: [PluginDependencyConfiguration] = [
        .init(plugin: .dependencyWheel, dependencies: [.sankey]),
        .init(plugin: .organization, dependencies: [.sankey]),
        .init(plugin: .arcDiagram, dependencies: [.sankey]),
        .init(plugin: .dumbbell, dependencies: [.highchartsMore]),
        .init(plugin: .lollipop, dependencies: [.dumbbell]),
        .init(plugin: .tilemap, dependencies: [.heatmap]),
        .init(plugin: .treegraph, dependencies: [.treemap])
    ]
    
    /// Priority plugins that should be loaded first
    private static let priorityPlugins: [AAChartPluginScriptType] = [
        .sankey,
        .heatmap,
        .dumbbell,
        .treemap
    ]

    private static let priorityByFileName: [String: Int] = {
        Dictionary(uniqueKeysWithValues: priorityPlugins.enumerated().map { index, plugin in
            (plugin.fileName, index)
        })
    }()

    // Helper function to sort plugin paths based on known dependencies
    private func sortPluginPaths(
        _ paths: Set<String>,
        merging externalDependencies: [String: String]
    ) -> [String] {
        guard paths.count > 1 else {
            return Array(paths).sorted()
        }

        let fileNameToPath = paths.reduce(into: [String: String]()) { result, path in
            let fileName = (path as NSString).lastPathComponent
            if let existing = result[fileName], existing <= path {
                return
            }
            result[fileName] = path
        }

        let dependencyMap = mergedDependencies(merging: externalDependencies)

        var adjacencyList = [String: Set<String>]()
        var inDegree = [String: Int]()
        paths.forEach { inDegree[$0] = 0 }

        for (dependentFileName, dependencyFileNames) in dependencyMap {
            guard let dependentPath = fileNameToPath[dependentFileName] else {
                continue
            }

            for dependencyFileName in dependencyFileNames {
                guard
                    let dependencyPath = fileNameToPath[dependencyFileName],
                    dependencyPath != dependentPath
                else {
                    continue
                }

                if adjacencyList[dependencyPath, default: []].insert(dependentPath).inserted {
                    inDegree[dependentPath, default: 0] += 1
                }
            }
        }

        func sortByPriorityThenPath(_ candidatePaths: [String]) -> [String] {
            candidatePaths.sorted { lhs, rhs in
                let lhsFileName = (lhs as NSString).lastPathComponent
                let rhsFileName = (rhs as NSString).lastPathComponent

                let lhsPriority = Self.priorityByFileName[lhsFileName] ?? Int.max
                let rhsPriority = Self.priorityByFileName[rhsFileName] ?? Int.max
                if lhsPriority != rhsPriority {
                    return lhsPriority < rhsPriority
                }
                return lhs < rhs
            }
        }

        var zeroInDegreePaths = sortByPriorityThenPath(
            paths.filter { (inDegree[$0] ?? 0) == 0 }
        )
        var sortedPaths: [String] = []
        sortedPaths.reserveCapacity(paths.count)

        while let nextPath = zeroInDegreePaths.first {
            zeroInDegreePaths.removeFirst()
            sortedPaths.append(nextPath)

            for dependentPath in adjacencyList[nextPath] ?? [] {
                let updatedInDegree = (inDegree[dependentPath] ?? 0) - 1
                inDegree[dependentPath] = updatedInDegree
                if updatedInDegree == 0 {
                    zeroInDegreePaths.append(dependentPath)
                }
            }
            zeroInDegreePaths = sortByPriorityThenPath(zeroInDegreePaths)
        }

        if sortedPaths.count != paths.count {
            let unresolvedPaths = paths.subtracting(Set(sortedPaths))
            let fallbackPaths = sortByPriorityThenPath(Array(unresolvedPaths))
            sortedPaths.append(contentsOf: fallbackPaths)

            #if DEBUG
            debugLog("⚠️ [ProPluginLoader] Cyclic or unresolved plugin dependencies detected. Falling back to priority/name ordering for unresolved scripts.")
            #endif
        }

        #if DEBUG
        let initialNames = Array(paths).map { ($0 as NSString).lastPathComponent }.sorted()
        let sortedNames = sortedPaths.map { ($0 as NSString).lastPathComponent }
        if paths.count > 1 && initialNames != sortedNames {
             debugLog("🔩 [ProPluginLoader] Sorted plugin load order: \(sortedNames)")
        }
        #endif

        return sortedPaths
    }

    private func mergedDependencies(merging externalDependencies: [String: String]) -> [String: Set<String>] {
        var dependencies = [String: Set<String>]()

        for configuration in Self.pluginDependencies {
            let dependent = configuration.plugin.fileName
            let requiredFiles = configuration.dependencies.map { $0.fileName }
            dependencies[dependent, default: []].formUnion(requiredFiles)
        }

        for (dependentRaw, dependencyRaw) in externalDependencies {
            let dependent = normalizedFileName(from: dependentRaw)
            let dependency = normalizedFileName(from: dependencyRaw)

            guard !dependent.isEmpty, !dependency.isEmpty else {
                continue
            }
            // Keep compatibility with previous behavior where external definitions override internal ones.
            dependencies[dependent] = [dependency]
        }

        return dependencies
    }

    private func normalizedFileName(from pathOrFileName: String) -> String {
        let fileName = (pathOrFileName as NSString).lastPathComponent
        return fileName.isEmpty ? pathOrFileName : fileName
    }

    // Function to load and evaluate scripts as a single combined batch
    private func loadAndEvaluateCombinedPluginScript(
        webView: WKWebView,
        scriptsToLoad: Set<String>,
        dependencies: [String: String],
        completion: @escaping (Set<String>) -> Void
    ) {
        guard !scriptsToLoad.isEmpty else {
            completeOnMainThread(with: Set(), completion: completion)
            return
        }

        let sortedScriptPaths = sortPluginPaths(scriptsToLoad, merging: dependencies)

        pluginIOQueue.async { [weak self, weak webView] in
            guard let self else {
                DispatchQueue.main.async {
                    completion(Set())
                }
                return
            }

            guard let webView else {
                self.debugLog("⚠️ [ProPluginLoader] WKWebView was deallocated before evaluating plugin scripts. Skipping.")
                self.completeOnMainThread(with: Set(), completion: completion)
                return
            }

            var scriptChunks: [String] = []
            scriptChunks.reserveCapacity(sortedScriptPaths.count * 3)
            var successfullyReadPaths = Set<String>()

            for path in sortedScriptPaths {
                let scriptName = (path as NSString).lastPathComponent
                let pathKey = path as NSString

                guard let scriptBody = self.readPluginScript(at: pathKey, name: scriptName) else { continue }

                scriptChunks.append("// --- Start: \(scriptName) ---")
                scriptChunks.append(scriptBody)
                scriptChunks.append("// --- End: \(scriptName) ---")
                successfullyReadPaths.insert(path)
            }

            let combinedJSString = scriptChunks.joined(separator: "\n")
            guard !combinedJSString.isEmpty else {
                self.debugLog("⚠️ [ProPluginLoader] No plugin script content could be read. Nothing to evaluate.")
                self.completeOnMainThread(with: Set(), completion: completion)
                return
            }

            self.debugLog("ℹ️ [ProPluginLoader] Evaluating combined plugin scripts (\(successfullyReadPaths.count) files)...")

            self.evaluateOnMainThread(webView: webView, javaScript: combinedJSString) { error in
                if let error = error {
                     var errorDetails = "Error: \(error.localizedDescription)"
                     if let nsError = error as NSError? {
                         var userInfoString = ""
                         if !nsError.userInfo.isEmpty {
                             userInfoString = "\n    User Info:"
                             let sortedKeys = nsError.userInfo.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
                             for key in sortedKeys {
                                 if let value = nsError.userInfo[key] {
                                     userInfoString += "\n      - \(key): \(value)"
                                 }
                             }
                         }
                         errorDetails = """
                         Error Details:
                           - Domain: \(nsError.domain)
                           - Code: \(nsError.code)
                           - Description: \(nsError.localizedDescription)\(userInfoString)
                         """
                     }
                    self.debugLog("""
                    ❌ [ProPluginLoader] Error evaluating combined plugin scripts:
                    --------------------------------------------------
                    \(errorDetails)
                    --------------------------------------------------
                    """)
                    self.completeOnMainThread(with: Set(), completion: completion)
                } else {
                    self.completeOnMainThread(with: successfullyReadPaths, completion: completion)
                }
            }
        }
    }

    // Need a way to evaluate JS safely, similar to AAChartView's method
    // This could be passed in or made static/global if appropriate
    private func safeEvaluateJavaScriptString(webView: WKWebView, _ jsString: String) {
         evaluateOnMainThread(webView: webView, javaScript: jsString) { error in
             #if DEBUG
             if let error {
                 print("☠️☠️💀☠️☠️ [ProPluginLoader] JS WARNING: \(error)")
             }
             #endif
         }
     }

    // Debug log helper
    private func debugLog(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }

    private func evaluateOnMainThread(
        webView: WKWebView,
        javaScript: String,
        completion: @escaping (Error?) -> Void
    ) {
        onMainThread {
            webView.evaluateJavaScript(javaScript) { _, error in
                completion(error)
            }
        }
    }

    private func readPluginScript(at pathKey: NSString, name scriptName: String) -> String? {
        if let cachedScript = Self.scriptCache.object(forKey: pathKey) {
            return cachedScript as String
        }

        do {
            let jsString = try String(contentsOfFile: pathKey as String, encoding: .utf8)
            Self.scriptCache.setObject(jsString as NSString, forKey: pathKey)
            return jsString
        } catch {
            debugLog("❌ [ProPluginLoader] Failed to read plugin script file '\(scriptName)': \(error). Skipping.")
            return nil
        }
    }

    private func completeOnMainThread(
        with result: Set<String>,
        completion: @escaping (Set<String>) -> Void
    ) {
        onMainThread {
            completion(result)
        }
    }

    private func completeOnMainThread(_ completion: @escaping () -> Void) {
        onMainThread {
            completion()
        }
    }

    private func onMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}

#if DEBUG
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
extension AAChartViewPluginLoader {
    internal func sortedPluginPathsForTesting(
        _ paths: Set<String>,
        dependencies: [String: String]
    ) -> [String] {
        sortPluginPaths(paths, merging: dependencies)
    }
}
#endif
