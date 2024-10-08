// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BFGlassView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BFGlassView",
            targets: ["BFGlassView"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BFGlassView",
            dependencies: []),
        .testTarget(
            name: "BFGlassViewTests",
            dependencies: ["BFGlassView"]),
    ]
)
