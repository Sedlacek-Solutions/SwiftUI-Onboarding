//
//  ButtonStyle+Primary.swift
//
//  Created by James Sedlacek on 7/5/26.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    let accentColor: Color
    let height: CGFloat

    private var backgroundColor: Color {
        isEnabled ? accentColor : accentColor.opacity(0.2)
    }

    private var foregroundColor: Color {
        isEnabled ? .white : accentColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                backgroundColor,
                in: .capsule
            )
            .foregroundStyle(foregroundColor)
            .font(.title3.weight(.semibold))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    @MainActor @preconcurrency
    static var primary: PrimaryButtonStyle {
        .init(accentColor: .blue, height: 48)
    }

    @MainActor @preconcurrency
    static func primary(
        accentColor: Color,
        height: CGFloat = 48
    ) -> PrimaryButtonStyle {
        .init(accentColor: accentColor, height: height)
    }
}

#Preview {
    VStack(spacing: 16) {
        Button("Continue") {}
            .buttonStyle(.primary)

        Button("Continue") {}
            .buttonStyle(.primary)
            .disabled(true)
    }
    .padding()
}
