import Foundation

// Protocol defining the responsibility for providing required plugin paths
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
internal protocol AAChartViewPluginProviderProtocol: AnyObject {
    func getRequiredPluginPaths(for options: AAOptions) -> Set<String>
}

// Default provider (can be used for the standard version or as a base)
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
internal final class DefaultPluginProvider: AAChartViewPluginProviderProtocol {
    public init() {}

    public func getRequiredPluginPaths(for options: AAOptions) -> Set<String> {
        return Set()
    }
}

// Provider for the Pro version, handling specific chart type plugins
@available(iOS 10.0, macCatalyst 13.1, macOS 10.13, *)
internal final class AAChartViewPluginProvider: AAChartViewPluginProviderProtocol {
    public init(bundlePathLoader: BundlePathLoading = BundlePathLoader()) {
        self.bundlePathLoader = bundlePathLoader
    }

    private let bundlePathLoader: BundlePathLoading

    private enum PluginScript: String {
        case sankey = "AASankey"
        case dependencyWheel = "AADependency-Wheel"
        case networkgraph = "AANetworkgraph"
        case organization = "AAOrganization"
        case arcDiagram = "AAArc-Diagram"
        case venn = "AAVenn"
        case treemap = "AATreemap"
        case sunburst = "AASunburst"
        case flame = "AAFlame"
        case variablePie = "AAVariable-Pie"
        case variwide = "AAVariwide"
        case dumbbell = "AADumbbell"
        case lollipop = "AALollipop"
        case histogramBellcurve = "AAHistogram-Bellcurve"
        case bullet = "AABullet"
        case heatmap = "AAHeatmap"
        case tilemap = "AATilemap"
        case streamgraph = "AAStreamgraph"
        case xrange = "AAXrange"
        case timeline = "AATimeline"
        case solidGauge = "AASolid-Gauge"
        case vector = "AAVector"
        case itemSeries = "AAItem-Series"
        case dataGrouping = "AADatagrouping"
        case windbarb = "AAWindbarb"
        case wordcloud = "AAWordcloud"
        case treegraph = "AATreegraph"
        case pictorial = "AAPictorial"
        case parallelCoordinates = "AAParallel-Coordinates"
        case data = "AAData"
    }

    private struct ChartPluginConfiguration {
        let types: Set<AAChartType>
        let scripts: [PluginScript]

        init(types: [AAChartType], scripts: [PluginScript]) {
            self.types = Set(types)
            self.scripts = scripts
        }
    }

    private static let pluginConfigurations: [ChartPluginConfiguration] = [
        // --- Flow & Relationship Charts ---
        .init(types: [.sankey], scripts: [.sankey]),
        .init(types: [.dependencywheel], scripts: [.sankey, .dependencyWheel]),
        .init(types: [.networkgraph], scripts: [.networkgraph]),
        .init(types: [.organization], scripts: [.sankey, .organization]),
        .init(types: [.arcdiagram], scripts: [.sankey, .arcDiagram]),
        .init(types: [.venn], scripts: [.venn]),

        // --- Hierarchical Charts ---
        .init(types: [.treemap], scripts: [.treemap]),
        .init(types: [.sunburst], scripts: [.sunburst]),
        .init(types: [.flame], scripts: [.flame]),

        // --- Distribution & Comparison Charts ---
        .init(types: [.variablepie], scripts: [.variablePie]),
        .init(types: [.variwide], scripts: [.variwide]),
        .init(types: [.dumbbell], scripts: [.dumbbell]),
        .init(types: [.lollipop], scripts: [.dumbbell, .lollipop]),
        .init(types: [.histogram], scripts: [.histogramBellcurve]),
        .init(types: [.bellcurve], scripts: [.histogramBellcurve]),
        .init(types: [.bullet], scripts: [.bullet]),

        // --- Heatmap & Matrix Charts ---
        .init(types: [.heatmap], scripts: [.heatmap]),
        .init(types: [.tilemap], scripts: [.heatmap, .tilemap]),

        // --- Time, Range & Stream Charts ---
        .init(types: [.streamgraph], scripts: [.streamgraph]),
        .init(types: [.xrange], scripts: [.xrange]),
        .init(types: [.timeline], scripts: [.timeline]),

        // --- Gauge & Indicator Charts ---
        .init(types: [.solidgauge], scripts: [.solidGauge]),

        // --- Specialized & Other Charts ---
        .init(types: [.vector], scripts: [.vector]),
        .init(types: [.item], scripts: [.itemSeries]),
        .init(types: [.windbarb], scripts: [.dataGrouping, .windbarb]),
        .init(types: [.wordcloud], scripts: [.wordcloud]),
        .init(types: [.treegraph], scripts: [.treemap, .treegraph]),
        .init(types: [.pictorial], scripts: [.pictorial])
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
        guard let resolvedType = AAChartType(rawValue: chartType) else {
            return
        }

        let scripts = Self.pluginConfigurations.reduce(into: Set<PluginScript>()) { result, configuration in
            guard configuration.types.contains(resolvedType) else {
                return
            }
            configuration.scripts.forEach { result.insert($0) }
        }

        scripts.forEach { script in
            if let scriptPath = generateScriptPath(for: script) {
                requiredPaths.insert(scriptPath)
            }
        }
    }

    // Helper to add scripts based on specific AAOptions properties
    private func addChartPluginScripts(for options: AAOptions, into requiredPaths: inout Set<String>) {
        if options.chart?.parallelCoordinates == true,
           let scriptPath = generateScriptPath(for: .parallelCoordinates) {
            requiredPaths.insert(scriptPath)
        }

        if options.data != nil,
           let scriptPath = generateScriptPath(for: .data) {
            requiredPaths.insert(scriptPath)
        }
    }

    // Generates the full path for a given script name (moved from AAChartView)
    // Consider moving this to a shared utility if used elsewhere.
    private func generateScriptPath(for script: PluginScript) -> String? {
        let scriptName = script.rawValue
        guard let path = bundlePathLoader
            .path(forResource: scriptName,
                  ofType: "js",
                  inDirectory: "AAJSFiles.bundle/AAModules",
                  forLocalization: nil)
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

// MARK: - Bundle Path Loader Abstraction

internal protocol BundlePathLoading {
    func path(
        forResource name: String,
        ofType fileType: String,
        inDirectory subpath: String?,
        forLocalization localizationName: String?
    ) -> String?
}

extension BundlePathLoader: BundlePathLoading {}


