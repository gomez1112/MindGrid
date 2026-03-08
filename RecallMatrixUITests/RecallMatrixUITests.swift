//
//  RecallMatrixUITests.swift
//  RecallMatrixUITests
//
//  Created by Gerard Gomez on 12/24/24.
//

import XCTest

final class RecallMatrixUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Ensure onboarding is already dismissed so it doesn't block the UI
        app.launchArguments += ["-hasSeenOnboarding", "YES"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testStartGameButton() throws {
        let enterGameButton = app.buttons["EnterGameButton"]
        XCTAssertTrue(
            enterGameButton.waitForExistence(timeout: 5),
            "The 'Enter Game' button should be visible on the start screen."
        )
        enterGameButton.tap()
        
        let recallMatrixTitle = app.staticTexts["Recall Matrix"]
        XCTAssertTrue(recallMatrixTitle.waitForExistence(timeout: 5), "After tapping 'Enter Game', we should see a title with text 'Recall Matrix'.")
    }
    
    /// Test 2: Verify that the settings button is available (on the Start Screen) and opens SettingsView.
    @MainActor
    func testOpenSettings() throws {
        let settingsButton = app.buttons["SettingsButton"]
        
        XCTAssertTrue(
            settingsButton.waitForExistence(timeout: 5),
            "A 'Settings' button should be available on the start screen."
        )
        settingsButton.tap()
        
        let timeStepperLabel = app.staticTexts["Time per Round"]
        XCTAssertTrue(
            timeStepperLabel.waitForExistence(timeout: 5),
            "Expected to see 'Time per Round' label on the Settings screen."
        )
    }
    /// Test 3: Enter the game and verify the Start Game button exists.
    @MainActor
    func testStartButton() throws {
        let enterGameButton = app.buttons["EnterGameButton"]
        XCTAssertTrue(enterGameButton.waitForExistence(timeout: 5))
        enterGameButton.tap()
        
        let startGameButton = app.buttons["Start Game"]
        XCTAssertTrue(
            startGameButton.waitForExistence(timeout: 5),
            "The 'Start Game' button should be visible after entering the game."
        )
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
