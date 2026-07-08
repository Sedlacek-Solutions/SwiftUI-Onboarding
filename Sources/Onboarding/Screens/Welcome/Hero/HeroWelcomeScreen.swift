//
//  HeroWelcomeScreen.swift
//
//  Created by James Sedlacek on 7/5/26.
//

import SwiftUI

/// Hero-focused welcome layout with language selection and account sign-in affordance.
@MainActor
public struct HeroWelcomeScreen {
    public struct Configuration {
        public let accentColor: Color
        public let title: LocalizedStringKey
        public let ctaTitle: LocalizedStringKey
        public let accountPrompt: LocalizedStringKey
        public let signInTitle: LocalizedStringKey
        public let textBundle: Bundle?
        public let languageOptions: [OnboardingLanguageOption]
        public let selectedLanguageStorageKey: String
        public let defaultLanguageIdentifier: String
        public let continueAction: () -> Void
        public let signInAction: () -> Void
        public let languageSelectionAction: (OnboardingLanguageOption) -> Void
        let heroContent: AnyView

        public init<HeroContent: View>(
            accentColor: Color = .blue,
            title: LocalizedStringKey,
            ctaTitle: LocalizedStringKey = "Get Started",
            accountPrompt: LocalizedStringKey = "Already have an account?",
            signInTitle: LocalizedStringKey = "Sign in",
            textBundle: Bundle? = nil,
            languageOptions: [OnboardingLanguageOption],
            selectedLanguageStorageKey: String = "onboarding.selectedLanguageIdentifier",
            defaultLanguageIdentifier: String? = nil,
            continueAction: @escaping () -> Void = {},
            signInAction: @escaping () -> Void = {},
            languageSelectionAction: @escaping (OnboardingLanguageOption) -> Void = { _ in },
            @ViewBuilder heroContent: () -> HeroContent
        ) {
            self.accentColor = accentColor
            self.title = title
            self.ctaTitle = ctaTitle
            self.accountPrompt = accountPrompt
            self.signInTitle = signInTitle
            self.textBundle = textBundle
            self.languageOptions = languageOptions
            self.selectedLanguageStorageKey = selectedLanguageStorageKey
            self.defaultLanguageIdentifier = defaultLanguageIdentifier
                ?? languageOptions.first?.identifier
                ?? Locale.current.identifier
            self.continueAction = continueAction
            self.signInAction = signInAction
            self.languageSelectionAction = languageSelectionAction
            self.heroContent = AnyView(heroContent())
        }

        func with(continueAction: @escaping () -> Void) -> Self {
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
                continueAction: continueAction,
                signInAction: signInAction,
                languageSelectionAction: languageSelectionAction
            ) {
                heroContent
            }
        }
    }

    private let config: Configuration
    @AppStorage private var selectedLanguageIdentifier: String
    @State private var isAnimating = false
    @State private var isLanguageSheetPresented = false

    private enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 18
        static let verticalSpacing: CGFloat = 28
        static let minimumHeroHeight: CGFloat = 220
        static let heroHeightRatio: CGFloat = 0.82
        static let heroAspectRatio: CGFloat = 1.18
    }

    public init(config: Configuration) {
        self.config = config
        self._selectedLanguageIdentifier = AppStorage(
            wrappedValue: config.defaultLanguageIdentifier,
            config.selectedLanguageStorageKey
        )
    }

    private func onAppear() {
        normalizeSelectedLanguage()
        Animation.welcomeScreen.deferred {
            isAnimating = true
        }
    }

    private func normalizeSelectedLanguage() {
        guard !config.languageOptions.isEmpty else { return }

        if config.languageOptions.contains(where: { $0.identifier == selectedLanguageIdentifier }) {
            return
        }

        if config.languageOptions.contains(where: { $0.identifier == config.defaultLanguageIdentifier }) {
            selectedLanguageIdentifier = config.defaultLanguageIdentifier
        } else if let firstLanguage = config.languageOptions.first {
            selectedLanguageIdentifier = firstLanguage.identifier
        }
    }
}

@MainActor
public extension HeroWelcomeScreen.Configuration {
    static let mock = Self(
        accentColor: .blue,
        title: .heroTitle,
        ctaTitle: .heroCTATitle,
        accountPrompt: .heroAccountPrompt,
        signInTitle: .heroSignInTitle,
        textBundle: .module,
        languageOptions: [
            .init(identifier: "en", displayName: "English", flag: "🇺🇸", shortName: "EN"),
            .init(identifier: "de", displayName: "Deutsch", flag: "🇩🇪", shortName: "DE"),
            .init(identifier: "es", displayName: "Español", flag: "🇪🇸", shortName: "ES")
        ]
    ) {
        HeroPreviewCard(accentColor: .blue)
    }
}

@MainActor
extension HeroWelcomeScreen: View {
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: Layout.verticalSpacing) {
                    Spacer(minLength: 8)

                    heroSection(in: geometry.size)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, Layout.topPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(.background.secondary)
            .safeAreaInset(edge: .bottom, content: bottomSection)
            .environment(\.locale, selectedLocale)
            .id(selectedLanguageIdentifier)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    languagePicker
                }
            }
            .sheet(isPresented: $isLanguageSheetPresented) {
                HeroLanguagePickerSheet(
                    accentColor: config.accentColor,
                    languageOptions: config.languageOptions,
                    selectedLanguageIdentifier: $selectedLanguageIdentifier,
                    languageSelectionAction: config.languageSelectionAction
                )
                .environment(\.locale, selectedLocale)
            }
            .onAppear(perform: onAppear)
        }
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }

    private var selectedLocale: Locale {
        Locale(identifier: selectedLanguageIdentifier)
    }

    private var selectedLanguage: OnboardingLanguageOption? {
        config.languageOptions.first { $0.identifier == selectedLanguageIdentifier }
            ?? config.languageOptions.first
    }

    private func heroSection(in availableSize: CGSize) -> some View {
        let contentWidth = max(0, availableSize.width - (Layout.horizontalPadding * 2))
        let contentHeight = max(0, availableSize.height - Layout.topPadding - Layout.verticalSpacing)
        let proportionalHeight = contentHeight * Layout.heroHeightRatio
        let aspectHeight = contentWidth * Layout.heroAspectRatio
        let heroHeight = min(max(proportionalHeight, Layout.minimumHeroHeight), aspectHeight)

        return config.heroContent
            .frame(width: contentWidth, height: heroHeight)
            .scaleEffect(isAnimating ? 1 : 0.94)
            .opacity(isAnimating ? 1 : 0)
    }

    @ViewBuilder
    private var languagePicker: some View {
        if !config.languageOptions.isEmpty {
            Button {
                isLanguageSheetPresented = true
            } label: {
                HStack(spacing: 6) {
                    Text(selectedLanguage?.flag ?? "🌐")
                    Text(selectedLanguage?.shortName ?? selectedLanguageIdentifier.prefix(2).uppercased())
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(selectedLanguage?.displayName ?? selectedLanguageIdentifier))
        }
    }

    private func bottomSection() -> some View {
        HeroWelcomeBottomSection(
            accentColor: config.accentColor,
            title: config.title,
            ctaTitle: config.ctaTitle,
            accountPrompt: config.accountPrompt,
            signInTitle: config.signInTitle,
            textBundle: config.textBundle,
            continueAction: config.continueAction,
            signInAction: config.signInAction
        )
    }
}

#Preview("Hero") {
    HeroWelcomeScreen(config: .mock)
}

#Preview("Hero - Small iPhone", traits: .fixedLayout(width: 375, height: 667)) {
    HeroWelcomeScreen(config: .scalableImagePreview)
}

#Preview("Hero - Large iPhone", traits: .fixedLayout(width: 430, height: 932)) {
    HeroWelcomeScreen(config: .scalableImagePreview)
}

@MainActor
private extension HeroWelcomeScreen.Configuration {
    static let scalableImagePreview = Self(
        accentColor: .blue,
        title: "Track every calorie with AI assistance",
        ctaTitle: .heroCTATitle,
        accountPrompt: .heroAccountPrompt,
        signInTitle: .heroSignInTitle,
        textBundle: .module,
        languageOptions: [
            .init(identifier: "en", displayName: "English", flag: "🇺🇸", shortName: "EN"),
            .init(identifier: "de", displayName: "Deutsch", flag: "🇩🇪", shortName: "DE"),
            .init(identifier: "es", displayName: "Español", flag: "🇪🇸", shortName: "ES")
        ]
    ) {
        Image(systemName: "fork.knife.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.blue)
    }
}
