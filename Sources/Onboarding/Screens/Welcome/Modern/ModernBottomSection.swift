//
//  ModernBottomSection.swift
//
//  Created by James Sedlacek on 2/15/25.
//

import SwiftUI

@MainActor
struct ModernBottomSection {
    let accentColor: Color
    let termsOfServiceURL: URL
    let privacyPolicyURL: URL
    let continueAction: () -> Void
    @State private var isAnimating = false

    private func onAppear() {
        Animation.bottomSection.deferred {
            isAnimating = true
        }
    }
}

@MainActor
extension ModernBottomSection: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ModernDisclaimerSection(
                accentColor: accentColor,
                termsOfServiceURL: termsOfServiceURL,
                privacyPolicyURL: privacyPolicyURL
            )

            Button(action: continueAction) {
                Text(.actionContinue, bundle: .module)
            }
            .buttonStyle(.primary(accentColor: accentColor))
        }
        .padding(20)
        .background(.background.secondary)
        .opacity(isAnimating ? 1 : 0)
        .onAppear(perform: onAppear)
    }
}

#Preview {
    ModernBottomSection(
        accentColor: .blue,
        termsOfServiceURL: URL(string: "https://example.com/terms")!,
        privacyPolicyURL: URL(string: "https://example.com/privacy")!,
        continueAction: {}
    )
}
