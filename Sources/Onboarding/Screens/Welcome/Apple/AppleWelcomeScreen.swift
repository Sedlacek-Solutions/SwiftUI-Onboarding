//
//  AppleWelcomeScreen.swift
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@MainActor
public struct AppleWelcomeScreen {
    public struct Configuration {
        public let accentColor: Color
        public let appDisplayName: String
        public let appIcon: Image
        public let features: [FeatureInfo]
        public let privacyPolicyURL: URL?
        public let titleSectionAlignment: HorizontalAlignment
        public let continueAction: () -> Void

        public init(
            accentColor: Color = .blue,
            appDisplayName: String,
            appIcon: Image,
            features: [FeatureInfo],
            privacyPolicyURL: URL? = nil,
            titleSectionAlignment: HorizontalAlignment = .leading,
            continueAction: @escaping () -> Void = {}
        ) {
            self.accentColor = accentColor
            self.appDisplayName = appDisplayName
            self.appIcon = appIcon
            self.features = features
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
public extension AppleWelcomeScreen.Configuration {
    static let mock = Self(
        appDisplayName: .init("Onboarding"),
        appIcon: Image(.mockAppIconResource),
        features: [.mock, .mock2, .mock3, .mock4, .mock5, .mock6],
        privacyPolicyURL: URL(string: "https://example.com/privacy")
    )
}

@MainActor
extension AppleWelcomeScreen: View {
    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 40) {
                titleSection
                featureSection
            }
            .padding(.vertical, 24)
        }
        .scrollIndicators(.hidden)
        .onboardingCenteredScrollAnchor()
        .onboardingBasedOnSizeScrollBounce()
        .background(Color.onboardingSecondaryBackground)
        .safeAreaInset(edge: .bottom, content: bottomSection)
        .onAppear(perform: onAppear)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }

    private var titleSection: some View {
        AppleTitleSection(
            config: config,
            shouldShowAppIcon: !isAnimating
        )
        .offset(y: isAnimating ? 0 : 200)
    }

    private var featureSection: some View {
        AppleFeatureSection(config: config)
            .opacity(isAnimating ? 1 : 0)
            .padding(.horizontal, 48)
    }

    private func bottomSection() -> some View {
        AppleBottomSection(
            accentColor: config.accentColor,
            appDisplayName: config.appDisplayName,
            privacyPolicyURL: config.privacyPolicyURL,
            continueAction: config.continueAction
        )
    }
}

#Preview("Default") {
    AppleWelcomeScreen(config: .mock)
}
