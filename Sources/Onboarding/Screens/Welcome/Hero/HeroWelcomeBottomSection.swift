//
//  HeroWelcomeBottomSection.swift
//
//  Created by James Sedlacek on 7/5/26.
//

import SwiftUI

@MainActor
struct HeroWelcomeBottomSection {
    let accentColor: Color
    let title: LocalizedStringKey
    let ctaTitle: LocalizedStringKey
    let accountPrompt: LocalizedStringKey
    let signInTitle: LocalizedStringKey
    let textBundle: Bundle?
    let continueAction: () -> Void
    let signInAction: () -> Void
    @State private var isAnimating = false

    private func onAppear() {
        Animation.bottomSection.deferred {
            isAnimating = true
        }
    }
}

@MainActor
extension HeroWelcomeBottomSection: View {
    var body: some View {
        VStack(spacing: 18) {
            Text(title, bundle: textBundle)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.82)
                .padding(.horizontal, 4)

            Button(action: continueAction) {
                Text(ctaTitle, bundle: textBundle)
            }
            .buttonStyle(.primary(accentColor: accentColor, height: 54))

            Button(action: signInAction) {
                HStack(spacing: 4) {
                    Text(accountPrompt, bundle: textBundle)
                        .foregroundStyle(.secondary)
                    Text(signInTitle, bundle: textBundle)
                        .fontWeight(.semibold)
                        .foregroundStyle(accentColor)
                }
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 20)
        .background(.background.secondary)
        .opacity(isAnimating ? 1 : 0)
        .onAppear(perform: onAppear)
    }
}

#Preview {
    VStack {
        Spacer()
    }
    .safeAreaInset(edge: .bottom) {
        HeroWelcomeBottomSection(
            accentColor: .mint,
            title: "Track every calorie with AI",
            ctaTitle: "Get Started",
            accountPrompt: "Already have an account?",
            signInTitle: "Sign in",
            textBundle: nil,
            continueAction: {},
            signInAction: {}
        )
    }
}
