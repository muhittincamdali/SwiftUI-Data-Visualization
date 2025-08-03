// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIDataVisualization",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUIDataVisualization",
            targets: ["SwiftUIDataVisualization"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIDataVisualization",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Numerics", package: "swift-numerics"),
            ],
            path: "Sources/SwiftUIDataVisualization",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .unsafeFlags(["-enable-testing"], .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "SwiftUIDataVisualizationTests",
            dependencies: ["SwiftUIDataVisualization"],
            path: "Tests/SwiftUIDataVisualizationTests"
        ),
        .testTarget(
            name: "SwiftUIDataVisualizationPerformanceTests",
            dependencies: ["SwiftUIDataVisualization"],
            path: "Tests/SwiftUIDataVisualizationPerformanceTests"
        ),
        .testTarget(
            name: "SwiftUIDataVisualizationUITests",
            dependencies: ["SwiftUIDataVisualization"],
            path: "Tests/SwiftUIDataVisualizationUITests"
        ),
    ]
) 