// swift-tools-version: 5.9

import Foundation
import PackageDescription

let package = Package(
    name: "swift-timecode",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftTimecode", targets: ["SwiftTimecode"]),
        .library(name: "SwiftTimecodeCore", type: .static, targets: ["SwiftTimecodeCore"])
    ],
    dependencies: [
        // used only for Dev tests, not part of regular unit tests
        .package(url: "https://github.com/apple/swift-numerics", from: "1.1.1"),
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.2.4")
    ],
    targets: [
        .target(
            name: "SwiftTimecode",
            dependencies: ["SwiftTimecodeCore"]
        ),
        .target(
            name: "SwiftTimecodeCore",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftTimecodeCoreTests",
            dependencies: [
                "SwiftTimecodeCore",
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "TestingExtensions", package: "swift-testing-extensions"),
            ]
        ),
    ]
)

#if canImport(Darwin)
/// AV and UI targets are only compatible with Apple platforms.

package.products += [
    .library(name: "SwiftTimecodeAV", targets: ["SwiftTimecodeAV"]),
    .library(name: "SwiftTimecodeUI", targets: ["SwiftTimecodeUI"])
]

package.targets.first(where: { $0.name == "SwiftTimecode" })?.dependencies += [
    "SwiftTimecodeAV", "SwiftTimecodeUI"
]

package.targets += [
    .target(
        name: "SwiftTimecodeAV",
        dependencies: ["SwiftTimecodeCore"]
    ),
    .target(
        name: "SwiftTimecodeUI",
        dependencies: ["SwiftTimecodeCore"],
        linkerSettings: [
            .linkedFramework("SwiftUI", .when(platforms: [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]))
        ]
    ),
    .testTarget(
        name: "SwiftTimecodeAVTests",
        dependencies: [
            "SwiftTimecodeAV",
            .product(name: "TestingExtensions", package: "swift-testing-extensions"),
        ],
        resources: [.copy("TestResource/Media Files")]
    ),
    .testTarget(
        name: "SwiftTimecodeUITests",
        dependencies: [
            "SwiftTimecodeUI",
            .product(name: "TestingExtensions", package: "swift-testing-extensions"),
        ],
        linkerSettings: [
            .linkedFramework("SwiftUI", .when(platforms: [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]))
        ]
    )
]
#endif

/// Conditionally opt-in to Swift DocC Plugin when an environment flag is present.
if ProcessInfo.processInfo.environment["ENABLE_DOCC_PLUGIN"] != nil {
    package.dependencies += [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.5")
    ]
}
