// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "BuidlerMacroSample",
    platforms: [.macOS(.v15)],
    products: [.executable(name: "MyExecutable", targets: ["MyExecutable"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0")
    ],
    targets: [
        .executableTarget(
            name: "MyExecutable",
            dependencies: [
                .target(name: "BuilderMacro")
            ]
        ),
        .macro(
            name: "BuilderMacroImpl",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "BuilderMacro",
            dependencies: [
                .target(name: "BuilderMacroImpl")
            ]
        )
    ]
)
