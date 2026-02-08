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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testStartGameButton() throws {
        let enterGameButton = app.buttons["Enter Game"]
        XCTAssertTrue(enterGameButton.exists, "The 'Enter Game Button' should be visible on the start screen.")
        enterGameButton.tap()
        
        let recallMatrixTitle = app.staticTexts["Recall Matrix"]
        XCTAssertTrue(recallMatrixTitle.waitForExistence(timeout: 5), "After tapping 'Enter Game', we should see a title with text 'Recall Matrix'.")
    }
    
    /// Test 2: Verify that the settings button is available (on the Start Screen) and opens SettingsView.
    @MainActor
    func testOpenSettings() throws {
        // 1) Identify the Settings button or link
        //    If using a NavigationLink with label "Settings", you can look it up by Accessibility Label "Settings"
        let settingsButton = app.buttons["StartScreenSettingsButton"]
        
        XCTAssertTrue(settingsButton.exists, "A 'Settings' button should be available on the start screen.")
        settingsButton.tap()
        
        // 2) Verify that the Settings screen is now visible, perhaps by checking a known label
        //    For example, "Time per Round" label within the Form
        let timeStepperLabel = app.staticTexts["Time per Round"]
        XCTAssertTrue(
            timeStepperLabel.waitForExistence(timeout: 5),
            "Expected to see 'Time per Round' label on the Settings screen."
        )
    }
    /// Test 3: Check a simple “Tile” interaction (assuming you have a tile with an accessibility identifier).
    func testStartButton() throws {
        // 1) Start the game to move to the GridView.
        let enterGameButton = app.buttons["Enter Game"]
        XCTAssertTrue(enterGameButton.exists)
        enterGameButton.tap()
        
        // 3) Tap on a tile. Suppose each TileView has "TileButton_N" as an identifier, or "Tile at position..."
        let startGameButton  = app.buttons["Start Game"]
        XCTAssertTrue(startGameButton.exists)
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
