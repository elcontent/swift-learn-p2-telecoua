// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MatricesSwift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MatricesSwift", targets: ["MatricesSwift"])
    ],
    targets: [
        .executableTarget(
            name: "MatricesSwift",
            path: "MatricesSwift"
        ),
        .testTarget(
            name: "MatricesSwiftTests",
            dependencies: ["MatricesSwift"],
            path: "Tests/MatricesSwiftTests"
        )
    ],
    swiftLanguageModes: [.v5]
)
