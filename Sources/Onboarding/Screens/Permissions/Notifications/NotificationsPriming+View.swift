//
//  NotificationsPriming+View.swift
//
//  Created by James Sedlacek on 12/18/25.
//

import SwiftUI

@MainActor
extension NotificationsPriming: View {
    public var body: some View {
        ScrollView {
            devicePreview
                .padding(20)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 40) {
                copySection
                    .padding(.horizontal, 20)

                footer
            }
        }
        .background(Color.onboardingSecondaryBackground)
        .onAppear(perform: onAppear)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }

    private var footer: some View {
        VStack(spacing: 20) {
            Button(action: requestAuthorizationAndProceed) {
                Text(config.allowButtonTitle, bundle: config.bundle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .font(.title3.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)
            .tint(config.accentColor)
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }

            if let skipAction = config.skipAction {
                Button(action: skipAction) {
                    Text(config.skipButtonTitle ?? .notificationsSkipButton, bundle: config.bundle)
                        .font(.body.weight(.medium))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(Color.onboardingSecondaryBackground)
    }

    private var devicePreview: some View {
        RoundedRectangle(cornerRadius: 48, style: .continuous)
        .fill(Color.onboardingSecondaryBackground)
        .stroke(.secondary.opacity(0.6), lineWidth: 4)
        .mask {
            LinearGradient(
                colors: [.black, .black.opacity(0.01)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .frame(height: 400)
        .overlay {
            VStack(spacing: 16) {
                Text(config.statusTime, bundle: config.bundle)
                    .font(.system(size: 68).weight(.medium))
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(40)
        }
        .padding(20)
        .overlay {
            notificationPreview
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 80)
        }
    }

    private var notificationPreview: some View {
        HStack(spacing: 12) {
            appIconPreview

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(config.notificationTitle, bundle: config.bundle)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer(minLength: 0)

                    Text(config.notificationTimestamp, bundle: config.bundle)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.secondary)
                }

                Text(config.notificationBody, bundle: config.bundle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .background(
            Color.onboardingTertiaryBackground.opacity(0.9),
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.secondary.opacity(0.6), lineWidth: 1)
        }
    }

    private var appIconPreview: some View {
        Group {
            if let appIcon = config.appIcon {
                appIcon
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(config.accentColor.opacity(0.18))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "app.fill")
                            .foregroundStyle(config.accentColor)
                            .font(.title3)
                    )
            }
        }
    }

    private var copySection: some View {
        VStack(spacing: 12) {
            Text(config.title, bundle: config.bundle)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(config.accentColor)

            Text(config.subtitle, bundle: config.bundle)
                .font(.body.weight(.medium))
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NotificationsPriming(config: .mock)
}
