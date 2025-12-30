// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MyDesktopPet",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.4.0")
    ],
    targets: [
        .executableTarget(
            name: "MyDesktopPet",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm")
            ],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
