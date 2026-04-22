// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AAInfographics-Pro",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "AAInfographics-Pro", targets: ["AAInfographics-Pro"])
    ],
    targets: [
        .target(
            name: "AAInfographics-Pro",
            path: "AAInfographics-Pro",
            exclude: ["ProjectBundlePathLoader.swift"],
            resources: [
                .copy("AAJSFiles.bundle")
            ]
        ),
        .testTarget(
            name: "AAInfographicsProTests",
            dependencies: ["AAInfographics-Pro"],
            path: "Tests/AAInfographicsProTests"
        )
    ]
)
