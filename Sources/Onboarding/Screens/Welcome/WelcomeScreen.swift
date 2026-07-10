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

extension WelcomeScreen {
  public static func apple(
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

  public static func modern(
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

  public static func hero<HeroContent: View>(
    accentColor: Color = .blue,
    title: LocalizedStringKey,
    ctaTitle: LocalizedStringKey = "Get Started",
    accountPrompt: LocalizedStringKey = "Already have an account?",
    signInTitle: LocalizedStringKey = "Sign in",
    textBundle: Bundle? = nil,
    languageOptions: [OnboardingLanguageOption],
    selectedLanguageStorageKey: String = "onboarding.selectedLanguageIdentifier",
    defaultLanguageIdentifier: String? = nil,
    languageSelectionDelay: Duration = .milliseconds(200),
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
        languageSelectionDelay: languageSelectionDelay,
        signInAction: signInAction,
        languageSelectionAction: languageSelectionAction,
        heroContent: heroContent
      )
    )
  }

  public static func hero<TopContent: View, HeroContent: View>(
    accentColor: Color = .blue,
    title: LocalizedStringKey,
    ctaTitle: LocalizedStringKey = "Get Started",
    accountPrompt: LocalizedStringKey = "Already have an account?",
    signInTitle: LocalizedStringKey = "Sign in",
    textBundle: Bundle? = nil,
    languageOptions: [OnboardingLanguageOption],
    selectedLanguageStorageKey: String = "onboarding.selectedLanguageIdentifier",
    defaultLanguageIdentifier: String? = nil,
    languageSelectionDelay: Duration = .milliseconds(200),
    signInAction: @escaping () -> Void = {},
    languageSelectionAction: @escaping (OnboardingLanguageOption) -> Void = { _ in },
    topContentHeight: CGFloat,
    topContentSpacing: CGFloat = 28,
    bottomContentTopPadding: CGFloat = 18,
    @ViewBuilder topContent: () -> TopContent,
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
        languageSelectionDelay: languageSelectionDelay,
        signInAction: signInAction,
        languageSelectionAction: languageSelectionAction,
        topContentHeight: topContentHeight,
        topContentSpacing: topContentSpacing,
        bottomContentTopPadding: bottomContentTopPadding,
        topContent: topContent,
        heroContent: heroContent
      )
    )
  }

  public func with(continueAction: @escaping () -> Void) -> Self {
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
extension WelcomeScreen {
  public static let mock: Self = .apple(.mock)
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
