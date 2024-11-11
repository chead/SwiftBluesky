// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SwiftBluesky",
    products: [
        .library(
            name: "SwiftBluesky",
            targets: ["SwiftBluesky"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/chead/SwiftATProto.git",
            from: "0.1.3"
        ),
        .package(
            url: "https://github.com/Flight-School/AnyCodable",
            from: "0.6.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftBluesky",
            dependencies: [
                .product(name: "SwiftATProto", package: "SwiftATProto"),
                .product(name: "AnyCodable", package: "AnyCodable")
            ],
            resources: [
                .process("Lexicons")
            ]
        ),
        .testTarget(
            name: "SwiftBlueskyTests",
            dependencies: ["SwiftBluesky"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
