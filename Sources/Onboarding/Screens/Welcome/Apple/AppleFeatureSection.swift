//
//  AppleFeatureSection.swift
//  
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@MainActor
struct AppleFeatureSection: View {
    private let config: AppleWelcomeScreen.Configuration
    @State private var isAnimating: [Bool] = []

    init(config: AppleWelcomeScreen.Configuration) {
        self.config = config
        _isAnimating = .init(
            initialValue: Array(
                repeating: false,
                count: config.features.count
            )
        )
    }

    var body: some View {
        ForEach(
            config.features.indices,
            id: \.self,
            content: featureView
        )
    }

    private func featureView(for index: Int) -> some View {
        FeatureView(
            info: config.features[index],
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

struct FeatureView: View {
    private let info: FeatureInfo
    private let accentColor: Color

    init(info: FeatureInfo, accentColor: Color) {
        self.info = info
        self.accentColor = accentColor
    }

    var body: some View {
        HStack(spacing: 12) {
            iconImage

            VStack(alignment: .leading, spacing: 4) {
                titleText
                contentText
            }

            Spacer()
        }
    }

    private var iconImage: some View {
        info.image
            .font(.title)
            .foregroundStyle(accentColor)
            .frame(minWidth: 50)
    }

    private var titleText: some View {
        Text(info.title)
            .foregroundStyle(.primary)
            .font(.subheadline.weight(.semibold))
    }

    private var contentText: some View {
        Text(info.content)
            .foregroundColor(.secondary)
            .font(.subheadline)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            AppleFeatureSection(config: .mock)
        }
        .padding(40)
    }
    .onboardingCenteredScrollAnchor()
    .onboardingBasedOnSizeScrollBounce()
}
