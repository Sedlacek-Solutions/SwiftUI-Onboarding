//
//  ModernWelcomeScreen.swift
//
//  Created by James Sedlacek on 2/15/25.
//

import SwiftUI

/// Card-based welcome layout with inline terms/privacy links.
@MainActor
public struct ModernWelcomeScreen {
    /// Configuration for the modern welcome screen.
    public struct Configuration {
        public let accentColor: Color
        public let appDisplayName: String
        public let appIcon: Image
        public let features: [FeatureInfo]
        public let termsOfServiceURL: URL
        public let privacyPolicyURL: URL
        public let titleSectionAlignment: HorizontalAlignment
        public let continueAction: () -> Void

        public init(
            accentColor: Color = .blue,
            appDisplayName: String,
            appIcon: Image,
            features: [FeatureInfo],
            termsOfServiceURL: URL,
            privacyPolicyURL: URL,
            titleSectionAlignment: HorizontalAlignment = .center,
            continueAction: @escaping () -> Void = {}
        ) {
            self.accentColor = accentColor
            self.appDisplayName = appDisplayName
            self.appIcon = appIcon
            self.features = features
            self.termsOfServiceURL = termsOfServiceURL
            self.privacyPolicyURL = privacyPolicyURL
            self.titleSectionAlignment = titleSectionAlignment
            self.continueAction = continueAction
        }

        func with(continueAction: @escaping () -> Void) -> Self {
            .init(
                accentColor: accentColor,
                appDisplayName: appDisplayName,
                appIcon: appIcon,
                features: features,
                termsOfServiceURL: termsOfServiceURL,
                privacyPolicyURL: privacyPolicyURL,
                titleSectionAlignment: titleSectionAlignment,
                continueAction: continueAction
            )
        }
    }

    private let config: Configuration
    @State private var isAnimating = false

    public init(config: Configuration) {
        self.config = config
    }

    private func onAppear() {
        Animation.welcomeScreen.deferred {
            isAnimating = true
        }
    }
}

@MainActor
public extension ModernWelcomeScreen.Configuration {
    static let mock = Self(
        appDisplayName: .init("Onboarding"),
        appIcon: Image(.mockAppIconResource),
        features: [.mock, .mock2, .mock3, .mock4, .mock5, .mock6],
        termsOfServiceURL: URL(string: "https://example.com/terms")!,
        privacyPolicyURL: URL(string: "https://example.com/privacy")!
    )
}

@MainActor
extension ModernWelcomeScreen: View {
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                titleSection
                featureSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom, content: bottomSection)
        .background(Color.onboardingSecondaryBackground)
        .onAppear(perform: onAppear)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }

    private var titleSection: some View {
        ModernTitleSection(
            config: config,
            shouldShowAppIcon: !isAnimating
        )
        .offset(y: isAnimating ? 0 : 200)
    }

    private var featureSection: some View {
        ModernFeatureSection(config: config)
            .opacity(isAnimating ? 1 : 0)
    }

    private func bottomSection() -> some View {
        ModernBottomSection(
            accentColor: config.accentColor,
            termsOfServiceURL: config.termsOfServiceURL,
            privacyPolicyURL: config.privacyPolicyURL,
            continueAction: config.continueAction
        )
    }
}

#Preview("Modern") {
    ModernWelcomeScreen(config: .mock)
}
