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
    /// Configures the loader with options to determine required plugins and scripts.
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
        completion() // Immediately complete
    }

    public func executeBeforeDrawScript(webView: WKWebView) {
        // No pre-draw script for default
    }

    public func executeAfterDrawScript(webView: WKWebView) {
        // No post-draw script for default
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
            completion()
            return
        }

        debugLog("ℹ️ [ProPluginLoader] Preparing to load \(pluginsToLoad.count) new plugin scripts...")
        loadAndEvaluateCombinedPluginScript(
            webView: webView,
            scriptsToLoad: pluginsToLoad,
            dependencies: dependencies
        ) { [weak self] successfullyLoadedPlugins in
            guard let self = self else { return }
            self.loadedPluginPaths.formUnion(successfullyLoadedPlugins)

            #if DEBUG
            if successfullyLoadedPlugins.count < pluginsToLoad.count {
                print("⚠️ [ProPluginLoader] One or more plugin script files could not be read, or the combined script evaluation failed.")
            } else if !successfullyLoadedPlugins.isEmpty {
                print("✅ [ProPluginLoader] \(successfullyLoadedPlugins.count) new plugin scripts loaded and evaluated successfully.")
            }
            print("ℹ️ [ProPluginLoader] Total loaded plugins count: \(self.loadedPluginPaths.count)")
            #endif
            completion()
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

    // Helper function to sort plugin paths based on known dependencies
    private func sortPluginPaths(
        _ paths: Set<String>,
        merging externalDependencies: [String: String]
    ) -> [String] {
        var sortedPaths = Array(paths)
        
        // Base dependencies that are internal to the library
        var dependencies: [String: String] = [
            "AADependency-Wheel.js": "AASankey.js",
            "AAOrganization.js": "AASankey.js",
            "AALollipop.js": "AADumbbell.js",
            "AATilemap.js": "AAHeatmap.js",
            "AAArc-Diagram.js": "AASankey.js",
            "AATreegraph.js": "AATreemap.js"
        ]
        
        // Merge external dependencies, allowing them to override base dependencies if needed
        dependencies.merge(externalDependencies) { (_, new) in new }

        sortedPaths.sort { path1, path2 in
            let file1 = (path1 as NSString).lastPathComponent
            let file2 = (path2 as NSString).lastPathComponent

            if let dependency = dependencies[file2], dependency == file1 { return true }
            if let dependency = dependencies[file1], dependency == file2 { return false }
            if file1 == "AASankey.js" && file2 != "AASankey.js" { return true }
            if file2 == "AASankey.js" && file1 != "AASankey.js" { return false }
            if file1 == "AAHeatmap.js" && file2 != "AAHeatmap.js" { return true } // Prioritize Heatmap for Tilemap
            if file2 == "AAHeatmap.js" && file1 != "AAHeatmap.js" { return false }
            if file1 == "AADumbbell.js" && file2 != "AADumbbell.js" { return true } // Prioritize Dumbbell for Lollipop
            if file2 == "AADumbbell.js" && file1 != "AADumbbell.js" { return false }

            return path1 < path2
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

            var combinedJSString = ""
            var successfullyReadPaths = Set<String>()

            for path in sortedScriptPaths {
                let scriptName = (path as NSString).lastPathComponent
                let pathKey = path as NSString

                guard let scriptBody = self.readPluginScript(at: pathKey, name: scriptName) else { continue }

                combinedJSString += "// --- Start: \(scriptName) ---\n"
                combinedJSString += scriptBody
                combinedJSString += "\n// --- End: \(scriptName) ---\n\n"
                successfullyReadPaths.insert(path)
            }

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

    private func onMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
