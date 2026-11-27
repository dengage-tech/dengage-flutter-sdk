// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dengage_flutter",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        // Library name uses "-" instead of "_" (Flutter SPM convention).
        .library(name: "dengage-flutter", targets: ["dengage_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Pinned to the native iOS SDK version used by the Android/iOS release 1.1.10.
        // Geofence (DengageGeofence) is intentionally not added; it is loaded via reflection
        // by the plugin and only works when the app adds that product itself, same as CocoaPods.
        .package(url: "https://github.com/dengage-tech/dengage-ios-sdk", exact: "5.108.0")
    ],
    targets: [
        .target(
            name: "dengage_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "Dengage", package: "dengage-ios-sdk")
            ]
        )
    ]
)
