// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "mlx-swift",

    platforms: [
        .iOS(.v17)
    ],

    products: [
        .library(name: "MLX", targets: ["MLX"]),
        .library(name: "MLXRandom", targets: ["MLXRandom"]),
        .library(name: "MLXNN", targets: ["MLXNN"])
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
            exclude: [
                "mlx/mlx/backend/cuda",
                "mlx/mlx/backend/no_gpu",
                "mlx/mlx/backend/no_cpu",
                "mlx/mlx/distributed",
                "mlx/mlx/python",
                "mlx/examples",
                "mlx/tests"
            ],
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
                ),
                .define(
                    "METAL_PATH",
                    to: "\"default.metallib\""
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
            name: "MLXRandom",
            dependencies: [
                "MLX"
            ]
        ),

        .target(
            name: "MLXNN",
            dependencies: [
                "MLX"
            ]
        )
    ],

    cxxLanguageStandard: .gnucxx20
)
