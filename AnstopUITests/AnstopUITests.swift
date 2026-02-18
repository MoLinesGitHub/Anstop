import XCTest

final class AnstopUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func test_onboardingFlow_canContinueWithBasicAndReachHome() throws {
        let app = makeApp(arguments: ["UI_TESTING", "UI_TESTING_RESET"])
        app.launch()

        let nextButton = app.buttons["onboarding.next_button"]
        let continueButton = app.buttons["onboarding.continue_button"]
        let continueBasicButton = app.buttons["onboarding.continue_basic_button"]

        var attempts = 0
        while !continueBasicButton.exists, attempts < 8 {
            if nextButton.exists {
                nextButton.tap()
            } else if continueButton.exists {
                continueButton.tap()
            } else {
                _ = nextButton.waitForExistence(timeout: 1) || continueButton.waitForExistence(timeout: 1)
            }
            attempts += 1
        }

        XCTAssertTrue(
            continueBasicButton.waitForExistence(timeout: 6),
            "No apareció el botón de continuar con versión básica."
        )
        continueBasicButton.tap()

        XCTAssertTrue(
            app.buttons["home.panic_button"].waitForExistence(timeout: 8),
            "No se llegó a Home tras completar onboarding."
        )
    }

    @MainActor
    func test_panicFlow_reachesCompletionAndReturnsHome() throws {
        let app = makeApp(arguments: ["UI_TESTING", "UI_TESTING_RESET", "UI_TESTING_SKIP_ONBOARDING"])
        app.launch()

        let advanceButton = app.buttons["panic.advance_button"]
        if !advanceButton.waitForExistence(timeout: 3) {
            let debugOpenButton = app.buttons["home.debug_open_panic_button"]
            let panicButton = app.buttons["home.panic_button"]

            _ = panicButton.waitForExistence(timeout: 4) || debugOpenButton.waitForExistence(timeout: 4)

            var attemptsToOpenFlow = 0
            while !advanceButton.exists, attemptsToOpenFlow < 3 {
                if debugOpenButton.exists {
                    debugOpenButton.tap()
                } else if panicButton.exists {
                    panicButton.tap()
                }
                _ = advanceButton.waitForExistence(timeout: 2)
                attemptsToOpenFlow += 1
            }
        }
        XCTAssertTrue(
            advanceButton.waitForExistence(timeout: 8),
            "No se pudo abrir PanicFlow en UI testing."
        )

        var attempts = 0
        while !app.buttons["panic.back_home_button"].exists, attempts < 8 {
            advanceButton.tap()
            attempts += 1
        }

        XCTAssertTrue(app.buttons["panic.back_home_button"].waitForExistence(timeout: 6))
        app.buttons["panic.back_home_button"].tap()

        XCTAssertTrue(app.buttons["home.panic_button"].waitForExistence(timeout: 6))
    }

    @MainActor
    func test_premiumBanner_opensAndClosesPaywall() throws {
        let app = makeApp(arguments: ["UI_TESTING", "UI_TESTING_RESET", "UI_TESTING_SKIP_ONBOARDING"])
        app.launch()

        let premiumBannerButton = app.buttons["home.premium_banner_button"]
        XCTAssertTrue(premiumBannerButton.waitForExistence(timeout: 6))
        premiumBannerButton.tap()

        let paywallCloseButton = app.buttons["paywall.close_button"]
        if !paywallCloseButton.waitForExistence(timeout: 6) {
            premiumBannerButton.tap()
        }
        XCTAssertTrue(paywallCloseButton.waitForExistence(timeout: 8))
        paywallCloseButton.tap()

        XCTAssertTrue(app.buttons["home.panic_button"].waitForExistence(timeout: 6))
    }

    @MainActor
    private func makeApp(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        return app
    }
}
