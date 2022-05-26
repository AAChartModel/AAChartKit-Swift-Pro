// swift-tools-version:5.3
import PackageDescription

let package = Package(
     name: "AAInfographics-Pro",
     platforms: [
         .iOS(.v9),
         .macOS(.v10_11)
     ],
     products: [
         .library(name: "AAInfographics-Pro", targets: ["AAInfographics-Pro"])
     ],
     targets: [
        .target(
			name: "AAInfographics-Pro",
			path: "AAInfographics-ProDemo/AAInfographics-Pro",
            exclude: ["Info.plist", "ProjectBundlePathLoader.swift"],
			resources: [
				.copy("AAJSFiles.bundle")
			]
        )
     ]
 )
