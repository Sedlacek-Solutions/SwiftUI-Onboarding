//
//  FeatureInfo.swift
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

/// A model representing a single feature to be displayed in the onboarding flow.
///
/// `FeatureInfo` encapsulates the visual and textual information needed to present
/// a feature highlight during onboarding. Each feature consists of an icon, title,
/// and descriptive content.
///
/// ## Usage
///
/// ```swift
/// let feature = FeatureInfo(
///     image: Image(systemName: "heart.fill"),
///     title: "Health Tracking",
///     content: "Monitor your daily activity and health metrics with ease."
/// )
/// ```
public struct FeatureInfo: Identifiable {
    /// A unique identifier for the feature.
    ///
    /// Automatically generated UUID that conforms to the `Identifiable` protocol,
    /// allowing `FeatureInfo` instances to be used in SwiftUI `ForEach` loops.
    public let id: UUID = .init()

    /// The icon or image representing the feature.
    ///
    /// Typically uses SF Symbols or custom images to visually represent
    /// the feature being highlighted.
    public let image: Image

    /// The title or name of the feature.
    ///
    /// A concise, descriptive title that identifies the feature.
    /// Should be brief and easily scannable.
    public let title: LocalizedStringKey

    /// A detailed description of the feature.
    ///
    /// Provides additional context about what the feature does
    /// and how it benefits the user.
    public let content: LocalizedStringKey

    /// Creates a new feature info instance.
    ///
    /// - Parameters:
    ///   - image: The icon or image representing the feature
    ///   - title: The title or name of the feature
    ///   - content: A detailed description of the feature
    public init(
        image: Image,
        title: LocalizedStringKey,
        content: LocalizedStringKey
    ) {
        self.image = image
        self.title = title
        self.content = content
    }
}

@MainActor
public extension FeatureInfo {
    /// Mock feature representing cross-platform support.
    static let mock: FeatureInfo = .init(
        image: Image(systemName: "laptopcomputer.and.iphone"),
        title: "feature.crossplatform.title",
        content: "feature.crossplatform.content"
    )

    /// Mock feature representing multi-language support.
    static let mock2: FeatureInfo = .init(
        image: Image(systemName: "globe"),
        title: "feature.localization.title",
        content: "feature.localization.content"
    )

    /// Mock feature representing Swift 6.0 compatibility.
    static let mock3: FeatureInfo = .init(
        image: Image(systemName: "swift"),
        title: "feature.swift.title",
        content: "feature.swift.content"
    )

    /// Mock feature representing accessibility features.
    static let mock4: FeatureInfo = .init(
        image: Image(systemName: "accessibility"),
        title: "feature.accessibility.title",
        content: "feature.accessibility.content"
    )

    /// Mock feature representing easy customization.
    static let mock5: FeatureInfo = .init(
        image: Image(systemName: "paintbrush.fill"),
        title: "feature.customization.title",
        content: "feature.customization.content"
    )

    /// Mock feature representing light and dark mode support.
    static let mock6: FeatureInfo = .init(
        image: Image(systemName: "circle.lefthalf.filled"),
        title: "feature.appearance.title",
        content: "feature.appearance.content"
    )
}
