// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUI-Onboarding",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: PackageProduct.allCases.map(\.description),
    targets: InternalTarget.allCases.map(\.target)
)

// MARK: PackageProduct

fileprivate enum PackageProduct: CaseIterable {
    case onboarding

    var name: String {
        switch self {
        case .onboarding: "Onboarding"
        }
    }

    var targets: [InternalTarget] {
        switch self {
        case .onboarding:
            InternalTarget.allCases
        }
    }

    var description: PackageDescription.Product {
        switch self {
        case .onboarding:
            .library(
                name: self.name,
                targets: self.targets.map(\.title)
            )
        }
    }
}

// MARK: InternalTarget

fileprivate enum InternalTarget: CaseIterable {
    case onboarding

    var title: String {
        switch self {
        case .onboarding: return "Onboarding"
        }
    }

    var targetDependency: Target.Dependency {
        .target(name: title)
    }

    var dependencies: [Target.Dependency] {
        []
    }

    var resources: [Resource]? {
        switch self {
        case .onboarding:
            [
                .process("Resources/Media.xcassets"),
                .process("Resources/Localizable.xcstrings")
            ]
        }
    }

    var target: Target {
        .target(
            name: self.title,
            dependencies: self.dependencies,
            resources: self.resources
        )
    }
}
