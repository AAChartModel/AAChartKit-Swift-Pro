import Foundation
import XCTest
@testable import AAInfographics_Pro

final class AAChartViewPluginLoaderTests: XCTestCase {
    private func makeLoader() -> AAChartViewPluginLoader {
        AAChartViewPluginLoader(provider: AAChartViewDefaultPluginProvider())
    }

    private func assertComesBefore(
        _ firstFileName: String,
        _ secondFileName: String,
        in sortedPaths: [String],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard
            let firstIndex = sortedPaths.firstIndex(where: { ($0 as NSString).lastPathComponent == firstFileName }),
            let secondIndex = sortedPaths.firstIndex(where: { ($0 as NSString).lastPathComponent == secondFileName })
        else {
            XCTFail("Expected file names not found in sorted paths: \(sortedPaths)", file: file, line: line)
            return
        }
        XCTAssertLessThan(firstIndex, secondIndex, file: file, line: line)
    }

    func testSortedPluginPathsForTesting_RespectsInternalDependencyChain() {
        let loader = makeLoader()
        let paths: Set<String> = [
            "/tmp/AALollipop.js",
            "/tmp/AADumbbell.js",
            "/tmp/AAHighcharts-More.js"
        ]

        let sorted = loader.sortedPluginPathsForTesting(paths, dependencies: [:])

        assertComesBefore("AAHighcharts-More.js", "AADumbbell.js", in: sorted)
        assertComesBefore("AADumbbell.js", "AALollipop.js", in: sorted)
    }

    func testSortedPluginPathsForTesting_NormalizesExternalDependencyPaths() {
        let loader = makeLoader()
        let paths: Set<String> = [
            "/tmp/A.js",
            "/tmp/B.js"
        ]
        let dependencies: [String: String] = [
            "/var/mobile/B.js": "/Users/admin/A.js"
        ]

        let sorted = loader.sortedPluginPathsForTesting(paths, dependencies: dependencies)

        assertComesBefore("A.js", "B.js", in: sorted)
    }

    func testSortedPluginPathsForTesting_FallsBackWhenDependenciesCycle() {
        let loader = makeLoader()
        let paths: Set<String> = [
            "/tmp/B.js",
            "/tmp/A.js"
        ]
        let dependencies: [String: String] = [
            "A.js": "B.js",
            "B.js": "A.js"
        ]

        let sorted = loader.sortedPluginPathsForTesting(paths, dependencies: dependencies)

        XCTAssertEqual(Set(sorted), paths)
        XCTAssertEqual(sorted, ["/tmp/A.js", "/tmp/B.js"])
    }

    func testConfigure_ConsumesBeforeAndAfterDrawScripts() {
        let loader = makeLoader()
        let options = AAOptions()
        options.beforeDrawChartJavaScript = "window.beforeCalled = true;"
        options.afterDrawChartJavaScript = "window.afterCalled = true;"

        loader.configure(options: options)

        XCTAssertNil(options.beforeDrawChartJavaScript)
        XCTAssertNil(options.afterDrawChartJavaScript)
    }
}
