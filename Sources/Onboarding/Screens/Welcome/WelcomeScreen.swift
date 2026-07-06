//
//  WelcomeScreen.swift
//
//  Created by James Sedlacek on 1/20/25.
//

import SwiftUI

/// Defines the available welcome screen presentations for onboarding.
public enum WelcomeScreen {
    case apple(AppleWelcomeScreen.Configuration)
    case modern(ModernWelcomeScreen.Configuration)
    case hero(HeroWelcomeScreen.Configuration)
}

public extension WelcomeScreen {
    static func apple(
        accentColor: Color = .blue,
        appDisplayName: String,
        appIcon: Image,
        features: [FeatureInfo],
        privacyPolicyURL: URL? = nil,
        titleSectionAlignment: HorizontalAlignment = .leading
    ) -> Self {
        .apple(
            .init(
                accentColor: accentColor,
                appDisplayName: appDisplayName,
                appIcon: appIcon,
                features: features,
                privacyPolicyURL: privacyPolicyURL,
                titleSectionAlignment: titleSectionAlignment
            )
        )
    }

    static func modern(
        accentColor: Color = .blue,
        appDisplayName: String,
        appIcon: Image,
        features: [FeatureInfo],
        termsOfServiceURL: URL,
        privacyPolicyURL: URL
    ) -> Self {
        .modern(
            .init(
                accentColor: accentColor,
                appDisplayName: appDisplayName,
                appIcon: appIcon,
                features: features,
                termsOfServiceURL: termsOfServiceURL,
                privacyPolicyURL: privacyPolicyURL
            )
        )
    }

    static func hero<HeroContent: View>(
        accentColor: Color = .blue,
        title: LocalizedStringKey,
        ctaTitle: LocalizedStringKey = "Get Started",
        accountPrompt: LocalizedStringKey = "Already have an account?",
        signInTitle: LocalizedStringKey = "Sign in",
        textBundle: Bundle? = nil,
        languageOptions: [OnboardingLanguageOption],
        selectedLanguageStorageKey: String = "onboarding.selectedLanguageIdentifier",
        defaultLanguageIdentifier: String? = nil,
        signInAction: @escaping () -> Void = {},
        languageSelectionAction: @escaping (OnboardingLanguageOption) -> Void = { _ in },
        @ViewBuilder heroContent: () -> HeroContent
    ) -> Self {
        .hero(
            .init(
                accentColor: accentColor,
                title: title,
                ctaTitle: ctaTitle,
                accountPrompt: accountPrompt,
                signInTitle: signInTitle,
                textBundle: textBundle,
                languageOptions: languageOptions,
                selectedLanguageStorageKey: selectedLanguageStorageKey,
                defaultLanguageIdentifier: defaultLanguageIdentifier,
                signInAction: signInAction,
                languageSelectionAction: languageSelectionAction,
                heroContent: heroContent
            )
        )
    }

    func with(continueAction: @escaping () -> Void) -> Self {
        switch self {
        case let .apple(configuration):
            return .apple(configuration.with(continueAction: continueAction))
        case let .modern(configuration):
            return .modern(configuration.with(continueAction: continueAction))
        case let .hero(configuration):
            return .hero(configuration.with(continueAction: continueAction))
        }
    }
}

@MainActor
public extension WelcomeScreen {
    static let mock: Self = .apple(.mock)
}

@MainActor
extension WelcomeScreen: View {
    public var body: some View {
        switch self {
        case let .apple(configuration):
            AppleWelcomeScreen(config: configuration)
        case let .modern(configuration):
            ModernWelcomeScreen(config: configuration)
        case let .hero(configuration):
            HeroWelcomeScreen(config: configuration)
        }
    }
}
