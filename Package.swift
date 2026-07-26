// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "mlx-swift",

    platforms: [
        .iOS(.v17)
    ],

    products: [
        .library(name: "MLX", targets: ["MLX"]),
        .library(name: "MLXNN", targets: ["MLXNN"]),
        .library(name: "MLXRandom", targets: ["MLXRandom"])
    ],

    dependencies: [
        .package(
            url: "https://github.com/apple/swift-numerics.git",
            from: "1.0.0"
        )
    ],

    targets: [

        .target(
            name: "Cmlx",
            path: "Source/Cmlx",
            cSettings: [
                .headerSearchPath("mlx"),
                .headerSearchPath("mlx-c")
            ],
            cxxSettings: [
                .headerSearchPath("mlx"),
                .headerSearchPath("mlx-c"),
                .headerSearchPath("metal-cpp"),
                .define("MLX_USE_ACCELERATE"),
                .define("_METAL_"),
                .define(
                    "SWIFTPM_BUNDLE",
                    to: "\"mlx-swift_Cmlx\""
                )
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("Metal"),
                .linkedFramework("Accelerate")
            ]
        ),

        .target(
            name: "MLX",
            dependencies: [
                "Cmlx",
                .product(
                    name: "Numerics",
                    package: "swift-numerics"
                )
            ],
            exclude: [
                "GPU+CUDA.swift"
            ]
        ),

        .target(
            name: "MLXNN",
            dependencies: [
                "MLX"
            ]
        ),

        .target(
            name: "MLXRandom",
            dependencies: [
                "MLX"
            ]
        )
    ],

    cxxLanguageStandard: .gnucxx20
)
