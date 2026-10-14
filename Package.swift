// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftUIDataVisualization",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "SwiftUIDataVisualization", targets: ["SwiftUIDataVisualization"])
    ],
    targets: [
        .target(
            name: "SwiftUIDataVisualization",
            path: "Sources/SwiftUIDataVisualization"
        ),
        .testTarget(
            name: "SwiftUIDataVisualizationTests",
            dependencies: ["SwiftUIDataVisualization"]
        )
    ]
)
