// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftUIDataVisualization",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftUIDataVisualization", targets: ["SwiftUIDataVisualization"]),
    ],
    targets: [
        .target(
            name: "SwiftUIDataVisualization",
            path: "Sources/SwiftUIDataVisualization",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SwiftUIDataVisualizationTests",
            dependencies: ["SwiftUIDataVisualization"]
        )
    ]
)
