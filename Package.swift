// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "IAB-TCF-V2",
    products: [
        .library(name: "IAB-TCF-V2", targets: ["IAB-TCF-V2-API"]),
        .library(name: "IAB-TCF-V2-Utils", targets: ["IAB-TCF-V2-Utils"]),
    ],
    targets: [
        .target(name: "IAB-TCF-V2-API", dependencies: ["IAB-TCF-V2-Utils"], path: "Sources/API"),
        .target(name: "IAB-TCF-V2-Utils", path: "Sources/Utils"),
        .testTarget(name: "IAB-TCF-V2-Tests", dependencies: ["IAB-TCF-V2-API"]),
    ]
)
