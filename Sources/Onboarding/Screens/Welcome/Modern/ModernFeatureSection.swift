//
//  ModernFeatureSection.swift
//
//  Created by James Sedlacek on 2/15/25.
//

import SwiftUI

@MainActor
struct ModernFeatureSection: View {
    private let config: ModernWelcomeScreen.Configuration
    @State private var isAnimating: [Bool] = []

    init(config: ModernWelcomeScreen.Configuration) {
        self.config = config
        _isAnimating = .init(
            initialValue: Array(
                repeating: false,
                count: config.features.count
            )
        )
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(
                config.features.indices,
                id: \.self,
                content: cardView
            )
        }
    }

    private func cardView(for index: Int) -> some View {
        ModernFeatureCard(
            feature: config.features[index],
            accentColor: config.accentColor
        )
        .opacity(isAnimating[index] ? 1 : 0)
        .offset(y: isAnimating[index] ? 0 : 100)
        .onAppear {
            Animation.feature(index: index).deferred {
                isAnimating[index] = true
            }
        }
    }
}

private struct ModernFeatureCard: View {
    let feature: FeatureInfo
    let accentColor: Color

    var body: some View {
        HStack(spacing: 16) {
            feature.image
                .font(.title2.weight(.semibold))
                .frame(width: 40, height: 40)
                .foregroundStyle(accentColor)
                .background(
                    Color.onboardingTertiaryBackground,
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text(feature.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(feature.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            Color.onboardingSecondaryBackground,
            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
        )
    }
}

#Preview {
    ScrollView {
        ModernFeatureSection(config: .mock)
            .padding()
    }
}
