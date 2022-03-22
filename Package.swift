// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MMMTweaks",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "MMMTweaks",
            targets: ["MMMTweaks"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/mediamonks/Tweaks", .upToNextMajor(from: "2.4.0"))
    ],
    targets: [
        .target(
            name: "MMMTweaksObjC",
            dependencies: [
                "Tweaks"
            ],
            path: "Sources/MMMTweaksObjC",
            publicHeadersPath: "."
        ),
        .target(
            name: "MMMTweaks",
            dependencies: [
                "MMMTweaksObjC"
            ],
            path: "Sources/MMMTweaks"
        )
    ]
)
