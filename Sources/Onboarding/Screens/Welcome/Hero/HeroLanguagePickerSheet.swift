//
//  HeroLanguagePickerSheet.swift
//
//  Created by James Sedlacek on 7/5/26.
//

import SwiftUI

@MainActor
struct HeroLanguagePickerSheet {
    let accentColor: Color
    let languageOptions: [OnboardingLanguageOption]
    let selectedLanguageIdentifier: String
    let languageSelectionAction: (OnboardingLanguageOption) -> Void
    @Environment(\.dismiss) private var dismiss
}

@MainActor
extension HeroLanguagePickerSheet: View {
    var body: some View {
        NavigationStack {
            List(languageOptions) { language in
                Button {
                    languageSelectionAction(language)
                    dismiss()
                } label: {
                    HStack(spacing: 14) {
                        Text(language.flag ?? "🌐")
                            .font(.title2)
                            .frame(width: 34)

                        Text(language.displayName)
                            .font(.body)
                            .foregroundStyle(.primary)

                        Spacer()

                        if language.identifier == selectedLanguageIdentifier {
                            Image(systemName: "checkmark")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .navigationTitle(Text(.heroLanguageTitle, bundle: .module))
            .heroInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

private extension View {
    @ViewBuilder
    func heroInlineNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

#Preview {
    HeroLanguagePickerSheet(
        accentColor: .mint,
        languageOptions: [
            .init(identifier: "en", displayName: "English", flag: "🇺🇸", shortName: "EN"),
            .init(identifier: "de", displayName: "Deutsch", flag: "🇩🇪", shortName: "DE"),
            .init(identifier: "es", displayName: "Español", flag: "🇪🇸", shortName: "ES")
        ],
        selectedLanguageIdentifier: "en",
        languageSelectionAction: { _ in }
    )
}
