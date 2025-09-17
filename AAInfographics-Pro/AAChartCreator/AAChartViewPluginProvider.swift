import Foundation
import WebKit // Import WebKit for WKWebView usage in loader

// Protocol defining the responsibility for providing required plugin paths
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public protocol AAChartViewPluginProvider {
    func getRequiredPluginPaths(for options: AAOptions) -> Set<String>
}

// Default provider (can be used for the standard version or as a base)
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class DefaultPluginProvider: AAChartViewPluginProvider {
    public init() {} // Public initializer

    public func getRequiredPluginPaths(for options: AAOptions) -> Set<String> {
        // Standard version might return empty or handle truly common plugins if any exist
        // For now, returning empty as per the abstraction goal.
        return ProPluginProvider.init().getRequiredPluginPaths(for: options)
    }
}

// Provider for the Pro version, handling specific chart type plugins
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public class ProPluginProvider: AAChartViewPluginProvider {
    public init() {} // Public initializer

    // Mapping from chart type rawValue to script names (moved from AAChartView)
    private static let chartTypeScriptMapping: [String: [String]] = [
        // --- Flow & Relationship Charts ---
        AAChartType.sankey.rawValue          : ["AASankey"],
        AAChartType.dependencywheel.rawValue : [
            "AASankey",
            "AADependency-Wheel"
        ],
        AAChartType.networkgraph.rawValue    : ["AANetworkgraph"],
        AAChartType.organization.rawValue    : [
            "AASankey",
            "AAOrganization"
        ],
        AAChartType.arcdiagram.rawValue      : [
            "AASankey",
            "AAArc-Diagram"
        ],
        AAChartType.venn.rawValue            : ["AAVenn"], // Can also be considered set theory

        // --- Hierarchical Charts ---
        AAChartType.treemap.rawValue         : ["AATreemap"],
        AAChartType.sunburst.rawValue        : ["AASunburst"],
        AAChartType.flame.rawValue           : ["AAFlame"], // Often used for profiling/hierarchy

        // --- Distribution & Comparison Charts ---
        AAChartType.variablepie.rawValue     : ["AAVariable-Pie"],
        AAChartType.variwide.rawValue        : ["AAVariwide"],
        AAChartType.dumbbell.rawValue        : ["AADumbbell"],
        AAChartType.lollipop.rawValue        : [
            "AADumbbell",
            "AALollipop"
        ],
        AAChartType.histogram.rawValue       : ["AAHistogram-Bellcurve"],
        AAChartType.bellcurve.rawValue       : ["AAHistogram-Bellcurve"],
        AAChartType.bullet.rawValue          : ["AABullet"], // Can also be gauge/indicator

        // --- Heatmap & Matrix Charts ---
        AAChartType.heatmap.rawValue         : ["AAHeatmap"],
        AAChartType.tilemap.rawValue         : [
            "AAHeatmap",
            "AATilemap"
        ],

        // --- Time, Range & Stream Charts ---
        AAChartType.streamgraph.rawValue     : ["AAStreamgraph"],
        AAChartType.xrange.rawValue          : ["AAXrange"],
        AAChartType.timeline.rawValue        : ["AATimeline"],

        // --- Gauge & Indicator Charts ---
        AAChartType.solidgauge.rawValue      : ["AASolid-Gauge"],
        // AAChartType.bullet is listed under Distribution/Comparison but fits here too

        // --- Specialized & Other Charts ---
        AAChartType.vector.rawValue          : ["AAVector"],
        AAChartType.item.rawValue            : ["AAItem-Series"], // Specific series type
        AAChartType.windbarb.rawValue        : [
            "AADatagrouping",
            "AAWindbarb"
        ], // Meteorological
        AAChartType.wordcloud.rawValue       : ["AAWordcloud"], // Text visualization
        AAChartType.treegraph.rawValue       : [
            "AATreemap",
            "AATreegraph"
        ],
    ]

    public func getRequiredPluginPaths(for options: AAOptions) -> Set<String> {
        var requiredPaths = Set<String>()

        // Check for plugins based on AAOptions properties
        addChartPluginScripts(for: options, into: &requiredPaths)

        // Check for plugins based on the main chart type
        if let chartType = options.chart?.type {
            addChartPluginScripts(forType: chartType, into: &requiredPaths)
        }

        // Check for plugins based on individual series types
        if let seriesArray = options.series {
            for seriesElement in seriesArray {
                if let finalSeriesElement = seriesElement as? AASeriesElement,
                   let seriesType = finalSeriesElement.type {
                    addChartPluginScripts(forType: seriesType, into: &requiredPaths)
                }
            }
        }

        return requiredPaths
    }

    // Helper to add scripts based on chart type string
    private func addChartPluginScripts(forType chartType: String, into requiredPaths: inout Set<String>) {
        guard let scriptNames = Self.chartTypeScriptMapping[chartType] else {
            return
        }
        scriptNames.forEach { scriptName in
            if let scriptPath = generateScriptPathWithScriptName(scriptName) {
                requiredPaths.insert(scriptPath)
            }
        }
    }

    // Helper to add scripts based on specific AAOptions properties
    private func addChartPluginScripts(for options: AAOptions, into requiredPaths: inout Set<String>) {
        if options.chart?.parallelCoordinates == true {
            if let scriptPath = generateScriptPathWithScriptName("AAParallel-Coordinates") {
                requiredPaths.insert(scriptPath)
            }
        }
        if options.data != nil {
             if let scriptPath = generateScriptPathWithScriptName("AAData") {
                requiredPaths.insert(scriptPath)
            }
        }
        // Add checks for other options properties that require specific plugins if needed
    }

    // Generates the full path for a given script name (moved from AAChartView)
    // Consider moving this to a shared utility if used elsewhere.
    private func generateScriptPathWithScriptName(_ scriptName: String) -> String? {
        // Assuming BundlePathLoader is accessible here or refactored.
        // If BundlePathLoader is specific to AAChartView's context,
        // you might need to pass the bundle or path finding logic differently.
        guard let path = BundlePathLoader()
            .path(forResource: scriptName,
                  ofType: "js",
                  inDirectory: "AAJSFiles.bundle/AAModules")
        else {
            #if DEBUG
            print("⚠️ Warning: Could not find path for script '\(scriptName).js'")
            //断言
            assert(false, "⚠️ Warning: Could not find path for script '\(scriptName).js'")
            #endif
            return nil
        }
        
        let urlStr = NSURL.fileURL(withPath: path)
        return urlStr.path
    }
}

// --- New Plugin Loader Protocol and Implementations ---

@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
public protocol AAChartViewPluginLoader {
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
public class DefaultPluginLoader: AAChartViewPluginLoader {
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
public class ProPluginLoader: AAChartViewPluginLoader {
    private let pluginProvider: AAChartViewPluginProvider
    private var requiredPluginPaths: Set<String> = []
    private var loadedPluginPaths: Set<String> = []
    private var beforeDrawScript: String?
    private var afterDrawScript: String?

    public init(provider: AAChartViewPluginProvider) {
        self.pluginProvider = provider
    }

    public func configure(options: AAOptions) {
        // Determine required plugins using the provider
        self.requiredPluginPaths = pluginProvider.getRequiredPluginPaths(for: options)
        #if DEBUG
        debugLog("🔌 [ProPluginLoader] Determined requiredPluginPaths: \(requiredPluginPaths.map {($0 as NSString).lastPathComponent})")
        #endif

        // Store and clear pre/post draw scripts from options
        if options.beforeDrawChartJavaScript != nil {
            self.beforeDrawScript = options.beforeDrawChartJavaScript
            options.beforeDrawChartJavaScript = nil
        } else {
            self.beforeDrawScript = nil
        }

        if options.afterDrawChartJavaScript != nil {
            self.afterDrawScript = options.afterDrawChartJavaScript
            options.afterDrawChartJavaScript = nil
        } else {
            self.afterDrawScript = nil
        }
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
        if let script = beforeDrawScript {
            debugLog("📝 [ProPluginLoader] Executing BeforeDrawScript...")
            safeEvaluateJavaScriptString(webView: webView, script)
            beforeDrawScript = nil // Execute only once
        }
    }

    public func executeAfterDrawScript(webView: WKWebView) {
        if let script = afterDrawScript {
            debugLog("📝 [ProPluginLoader] Executing AfterDrawScript...")
            safeEvaluateJavaScriptString(webView: webView, script)
            afterDrawScript = nil // Execute only once
        }
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
            completion(Set())
            return
        }

        let sortedScriptPaths = sortPluginPaths(scriptsToLoad, merging: dependencies)
        var combinedJSString = ""
        var successfullyReadPaths = Set<String>()

        for path in sortedScriptPaths {
            let scriptName = (path as NSString).lastPathComponent
            do {
                let jsString = try String(contentsOfFile: path, encoding: .utf8)
                combinedJSString += "// --- Start: \(scriptName) ---\n"
                combinedJSString += jsString
                combinedJSString += "\n// --- End: \(scriptName) ---\n\n"
                successfullyReadPaths.insert(path)
            } catch {
                debugLog("❌ [ProPluginLoader] Failed to read plugin script file '\(scriptName)': \(error). Skipping.")
            }
        }

        guard !combinedJSString.isEmpty else {
            debugLog("⚠️ [ProPluginLoader] No plugin script content could be read. Nothing to evaluate.")
            completion(Set())
            return
        }

        debugLog("ℹ️ [ProPluginLoader] Evaluating combined plugin scripts (\(successfullyReadPaths.count) files)...")

        webView.evaluateJavaScript(combinedJSString) { _, error in
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
                completion(Set())
            } else {
                completion(successfullyReadPaths)
            }
        }
    }

    // Need a way to evaluate JS safely, similar to AAChartView's method
    // This could be passed in or made static/global if appropriate
    private func safeEvaluateJavaScriptString(webView: WKWebView, _ jsString: String) {
         webView.evaluateJavaScript(jsString, completionHandler: { (item, error) in
             #if DEBUG
             // Simplified error logging for brevity, reuse AAChartView's detailed logging if needed
             if error != nil {
                 print("☠️☠️💀☠️☠️ [ProPluginLoader] JS WARNING: \(error!)")
             }
             #endif
             // Note: Cannot call delegate method aaChartViewDidFinishEvaluate here directly
         })
     }

    // Debug log helper
    private func debugLog(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}

