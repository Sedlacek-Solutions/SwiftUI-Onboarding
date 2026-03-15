//
//  ModernTitleSection.swift
//
//  Created by James Sedlacek on 2/15/25.
//

import SwiftUI

@MainActor
struct ModernTitleSection {
    private let config: ModernWelcomeScreen.Configuration
    private let shouldShowAppIcon: Bool
    @State private var isAnimating = false

    init(
        config: ModernWelcomeScreen.Configuration,
        shouldShowAppIcon: Bool
    ) {
        self.config = config
        self.shouldShowAppIcon = shouldShowAppIcon
    }

    private func onAppear() {
        Animation.titleSection.deferred {
            isAnimating = true
        }
    }
}

@MainActor
extension ModernTitleSection: View {
    var body: some View {
        VStack(alignment: config.titleSectionAlignment, spacing: 2) {
            appIconView
            welcomeToText
            appDisplayNameText
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: config.titleSectionAlignment.toAlignment
        )
        .padding(.horizontal, 64)
        .font(.largeTitle)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1.0 : 0.5)
        .onAppear(perform: onAppear)
    }

    @ViewBuilder
    private var appIconView: some View {
        if shouldShowAppIcon {
            config.appIcon
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.bottom)
        }
    }

    private var welcomeToText: some View {
        Text(.onboardingWelcomeTo, bundle: .module)
            .foregroundStyle(.primary)
            .fontWeight(.semibold)
    }

    private var appDisplayNameText: some View {
        Text(config.appDisplayName)
            .foregroundStyle(config.accentColor)
            .fontWeight(.bold)
    }
}

#Preview {
    ModernTitleSection(
        config: .mock,
        shouldShowAppIcon: true
    )
}
