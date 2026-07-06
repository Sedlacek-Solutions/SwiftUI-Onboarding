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
        .background(.background.secondary)
        .onAppear(perform: onAppear)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }

    private var footer: some View {
        VStack(spacing: 20) {
            Button(action: requestAuthorizationAndProceed) {
                Text(config.allowButtonTitle, bundle: config.bundle)
            }
            .buttonStyle(.primary(accentColor: config.accentColor))
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
        .background(.background.secondary)
    }

    private var devicePreview: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 48,
            topTrailingRadius: 48,
            style: .continuous
        )
        .fill(.background.secondary)
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
                        .foregroundStyle(.secondary)
                }

                Text(config.notificationBody, bundle: config.bundle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .background(
            .background.tertiary.opacity(0.9),
            in: .rect(cornerRadius: 16)
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
                    .clipShape(.rect(cornerRadius: 12))
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
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NotificationsPriming(config: .mock)
}
