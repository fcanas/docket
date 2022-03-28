// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "docket",
    platforms: [.macOS(.v12)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "docket",
            dependencies: []),
        .testTarget(
            name: "docketTests",
            dependencies: ["docket"]),
    ]
)
