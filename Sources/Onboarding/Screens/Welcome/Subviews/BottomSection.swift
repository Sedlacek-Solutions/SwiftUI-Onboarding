//
//  BottomSection.swift
//  
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@MainActor
struct BottomSection<C: View> {
    private let accentColor: Color
    private let appDisplayName: String
    private let continueAction: () -> Void
    private let signInWithAppleConfiguration: SignInWithAppleButtonConfiguration?
    private let dataPrivacyContent: (() -> C)?
    @State private var isDataPrivacyPresented: Bool = false
    @State private var isAnimating: Bool = false

    init(
        accentColor: Color,
        appDisplayName: String,
        continueAction: @escaping () -> Void,
        signInWithAppleConfiguration: SignInWithAppleButtonConfiguration? = nil,
        @ViewBuilder dataPrivacyContent: @escaping () -> C
    ) {
        self.accentColor = accentColor
        self.appDisplayName = appDisplayName
        self.continueAction = continueAction
        self.signInWithAppleConfiguration = signInWithAppleConfiguration
        self.dataPrivacyContent = dataPrivacyContent
    }
    
    init(accentColor: Color,
         appDisplayName: String,
         continueAction: @escaping () -> Void,
         signInWithAppleConfiguration: SignInWithAppleButtonConfiguration? = nil) where C == EmptyView {
        self.accentColor = accentColor
        self.appDisplayName = appDisplayName
        self.continueAction = continueAction
        self.signInWithAppleConfiguration = signInWithAppleConfiguration
        self.dataPrivacyContent = nil
    }

    private func onAppear() {
        Animation.bottomSection.deferred {
            isAnimating = true
        }
    }

    private func disclosureAction() {
        isDataPrivacyPresented.toggle()
    }
}

@MainActor
extension BottomSection: View {
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            if (dataPrivacyContent != nil) {
                dataPrivacyImage
                disclosureText
            }
            continueButton
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 24)
        .background(.background.secondary)
        .mask(opacityLinearGradient)
        .opacity(isAnimating ? 1 : 0)
        .onAppear(perform: onAppear)
        .styledSheet(
            isPresented: $isDataPrivacyPresented,
            content: dataPrivacySheet
        )
    }

    private func dataPrivacySheet() -> some View {
        NavigationStack {
            if (dataPrivacyContent != nil) {
                dataPrivacyContent!()
            }
        }
    }

    private var dataPrivacyImage: some View {
        Image(.onboardingKitDataPrivacy)
            .resizable()
            .foregroundStyle(accentColor)
            .frame(width: 40, height: 40)
    }

    private var disclosureText: some View {
        Group {
            Text(verbatim: appDisplayName)
                .foregroundStyle(.secondary) +
            Text(.privacyDataCollection, bundle: .module)
                .foregroundStyle(.secondary) +
            Text(.privacyDataManagement, bundle: .module)
                .foregroundStyle(accentColor)
                .bold()
        }
        .multilineTextAlignment(.center)
        .font(.caption)
        .padding(.bottom, 24)
        .padding(.top, 6)
        .onTapGesture(perform: disclosureAction)
    }

    @ViewBuilder
    private var continueButton: some View {
        if let signInWithAppleConfiguration {
            SignInWithAppleButtonView(
                configuration: signInWithAppleConfiguration,
                continueAction: continueAction
            )
        } else {
            Button(
                action: continueAction,
                label: continueText
            )
            .font(.title3.weight(.medium))
            .buttonStyle(.borderedProminent)
            .tint(accentColor)
        }
    }

    private func continueText() -> some View {
        Text(.actionContinue, bundle: .module)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
    }

    private func opacityLinearGradient() -> some View {
        LinearGradient(
            colors: [.black.opacity(0.9), .black, .black, .black],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview("Data Privacy Content"){
    VStack {
        Spacer()
    }
    .safeAreaInset(edge: .bottom) {
        BottomSection(
            accentColor: .blue,
            appDisplayName: .init("Test App"),
            continueAction: {
                print("Continue Tapped")
            },
            dataPrivacyContent: {
                Text("Privacy Policy Content")
            }
        )
    }
}

#Preview("No Data Privacy Content"){
    VStack {
        Spacer()
    }
    .safeAreaInset(edge: .bottom) {
        BottomSection(
            accentColor: .blue,
            appDisplayName: .init("Test App"),
            continueAction: {
                print("Continue Tapped")
            }
        )
    }
}
