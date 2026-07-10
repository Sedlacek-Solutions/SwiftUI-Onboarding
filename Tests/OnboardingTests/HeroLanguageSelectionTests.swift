import Onboarding
import SwiftUI
import Testing

@Suite("Hero language selection")
struct HeroLanguageSelectionTests {
    @MainActor
    @Test("Uses the configured post-dismiss delay")
    func configuredDelay() {
        let configuration = HeroWelcomeScreen.Configuration(
            title: "Welcome",
            languageOptions: [
                .init(identifier: "en", displayName: "English")
            ],
            languageSelectionDelay: .milliseconds(200)
        ) {
            EmptyView()
        }

        #expect(configuration.languageSelectionDelay == .milliseconds(200))
    }
}
