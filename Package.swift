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

    targets: [

        .target(
            name: "Cmlx",
            path: "Source/Cmlx",

            exclude: [
                // Executable files
                "main.cpp",
                "main.swift",

                // CUDA
                "mlx/mlx/backend/cuda",

                // Metal shader sources
                "mlx/mlx/backend/metal/kernels",
                "mlx/mlx/backend/metal/jit",
                "mlx/mlx/backend/metal/*.metal",

                // Unsupported extras
                "mlx-c/examples",
                "mlx/examples",
                "mlx/tests",
                "tests",

                // Distributed
                "mlx/mlx/distributed"
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
                "Cmlx"
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
