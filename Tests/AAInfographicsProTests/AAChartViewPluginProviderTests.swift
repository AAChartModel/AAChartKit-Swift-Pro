import XCTest
@testable import AAInfographics_Pro

final class AAChartViewPluginProviderTests: XCTestCase {
    private final class MockBundlePathLoader: AAChartBundlePathLoadingProtocol {
        private(set) var pathLookupCounts: [String: Int] = [:]

        func path(
            forResource name: String,
            ofType fileType: String,
            inDirectory subpath: String?,
            forLocalization localizationName: String?
        ) -> String? {
            pathLookupCounts[name, default: 0] += 1
            let directory = subpath ?? ""
            return "/mock/\(directory)/\(name).\(fileType)"
        }
    }

    private func mockPath(for script: AAChartPluginScriptType) -> String {
        "/mock/AAJSFiles.bundle/\(script.directoryPrefix)/\(script.rawValue).js"
    }

    func testGetRequiredPluginPaths_DeduplicatesTypesAndCachesPathLookups() {
        let mockLoader = MockBundlePathLoader()
        let provider = AAChartViewPluginProvider(bundlePathLoader: mockLoader)

        let options = AAOptions()
        options.chart = AAChart().type(.lollipop)
        options.series = [
            AASeriesElement().type(.lollipop),
            AASeriesElement().type(.dumbbell),
            AASeriesElement().type(.lollipop)
        ]

        let paths = provider.getRequiredPluginPaths(for: options)

        let expectedPaths: Set<String> = [
            mockPath(for: .highchartsMore),
            mockPath(for: .dumbbell),
            mockPath(for: .lollipop)
        ]
        XCTAssertEqual(paths, expectedPaths)

        XCTAssertEqual(mockLoader.pathLookupCounts["AAHighcharts-More"], 1)
        XCTAssertEqual(mockLoader.pathLookupCounts["AADumbbell"], 1)
        XCTAssertEqual(mockLoader.pathLookupCounts["AALollipop"], 1)
    }

    func testGetRequiredPluginPaths_AddsOptionDrivenPlugins() {
        let mockLoader = MockBundlePathLoader()
        let provider = AAChartViewPluginProvider(bundlePathLoader: mockLoader)

        let options = AAOptions()
        options.chart = AAChart().polar(true)
        options.chart?.parallelCoordinates = true
        options.data = AAData()

        let paths = provider.getRequiredPluginPaths(for: options)

        let expectedPaths: Set<String> = [
            mockPath(for: .highchartsMore),
            mockPath(for: .parallelCoordinates),
            mockPath(for: .data)
        ]
        XCTAssertEqual(paths, expectedPaths)
    }

    func testGetRequiredPluginPaths_CachesScriptPathAcrossCalls() {
        let mockLoader = MockBundlePathLoader()
        let provider = AAChartViewPluginProvider(bundlePathLoader: mockLoader)

        let options = AAOptions()
        options.chart = AAChart().type(.sankey)

        let first = provider.getRequiredPluginPaths(for: options)
        let second = provider.getRequiredPluginPaths(for: options)

        XCTAssertEqual(first, second)
        XCTAssertEqual(mockLoader.pathLookupCounts["AASankey"], 1)
    }
}
