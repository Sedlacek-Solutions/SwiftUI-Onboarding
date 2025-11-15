//
//  View+StyledSheet.swift
//  OnboardingKit
//
//  Created by James Sedlacek on 7/3/25.
//

import SwiftUI

extension View {
    func styledSheet<C: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> C
    ) -> some View {
        modifier(
            StyledSheetModifier(
                isPresented: isPresented,
                sheetContent: content
            )
        )
    }
}

@MainActor
struct StyledSheetModifier<C: View>: ViewModifier {
    private let sheetContent: () -> C
    @Binding private var isPresented: Bool

    init(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetContent: @escaping () -> C
    ) {
        self.sheetContent = sheetContent
        self._isPresented = isPresented
    }

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented,
                content: styledSheetContent
            )
    }

    private func styledSheetContent() -> some View {
        NavigationStack {
            sheetContent()
                .toolbar(content: dismissButton)
        }
    }

    private func dismissButton() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            if #available(iOS 26, macOS 26, *) {
                Button(role: .close, action: buttonAction)
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("DismissButton")
            }
            else {
                Button(action: buttonAction, label: buttonLabel)
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("DismissButton")
            }
        }
    }

    private func buttonLabel() -> some View {
#if os(iOS)
        Image(systemName: "xmark")
            .symbolVariant(.circle.fill)
            .font(.system(size: 22, weight: .medium))
            .foregroundStyle(Color.gray, .background.secondary)
#elseif os(macOS)
        Text(.actionDone, bundle: .module)
            .font(.body)
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.blue, in: .rect(cornerRadius: 4))
#endif
    }

    private func buttonAction() {
        isPresented = false
    }
}


