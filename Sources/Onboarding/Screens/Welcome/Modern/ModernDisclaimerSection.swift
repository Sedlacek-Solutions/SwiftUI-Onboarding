//
//  ModernDisclaimerSection.swift
//
//  Created by James Sedlacek on 2/15/25.
//

import SwiftUI

@MainActor
struct ModernDisclaimerSection: View {
    @Environment(\.openURL) private var openURL
    let accentColor: Color
    let termsOfServiceURL: URL
    let privacyPolicyURL: URL

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(.modernDisclaimerPrefix, bundle: .module)
                .font(.footnote)
                .foregroundColor(.secondary)

            HStack(spacing: 4) {
                Text(.modernDisclaimerTerms, bundle: .module)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(accentColor)
                    .onTapGesture {
                        openURL(termsOfServiceURL)
                    }
                Text(.modernDisclaimerAnd, bundle: .module)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(.modernDisclaimerPrivacy, bundle: .module)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(accentColor)
                    .onTapGesture {
                        openURL(privacyPolicyURL)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 4)
    }
}

#Preview {
    ModernDisclaimerSection(
        accentColor: .blue,
        termsOfServiceURL: URL(string: "https://example.com/terms")!,
        privacyPolicyURL: URL(string: "https://example.com/privacy")!
    )
}
