//
//  View+Compatibility.swift
//
//  Created by James Sedlacek on 3/15/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    static var onboardingSecondaryBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
#elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
#else
        Color.secondary
#endif
    }

    static var onboardingTertiaryBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .tertiarySystemBackground)
#elseif canImport(AppKit)
        Color(nsColor: .controlBackgroundColor)
#else
        Color.secondary.opacity(0.5)
#endif
    }
}

extension View {
    @ViewBuilder
    func onboardingCenteredScrollAnchor() -> some View {
        if #available(iOS 18, macOS 15, *) {
            self.defaultScrollAnchor(.center, for: .alignment)
        } else {
            self
        }
    }

    @ViewBuilder
    func onboardingBasedOnSizeScrollBounce() -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            self.scrollBounceBehavior(.basedOnSize)
        } else {
            self
        }
    }
}