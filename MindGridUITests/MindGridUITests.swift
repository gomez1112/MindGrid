//
//  MindGridUITests.swift
//  MindGridUITests
//
//  Created by Gerard Gomez on 12/1/24.
//

import XCTest

final class MindGrid: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testStartGameButtonExists() throws {
        let startButton = app.buttons["Start Game"]
        XCTAssertTrue(startButton.exists, "Start Game button should exist")
    }
    
    func testGameOver() throws {
        // Simulate incorrect selections to reduce score to 0
        let startButton = app.buttons["Start Game"]
        startButton.tap()
        
        let checkResultButton = app.buttons["Check Result"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: checkResultButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Simulate incorrect selections until game over
        for _ in 0..<5 {
            checkResultButton.tap()
            
            // Wait for "Next Round" or "Game Over" screen
            let nextButton = app.buttons["Next Round"]
            let gameOverText = app.staticTexts["Game Over"]
            
            if gameOverText.exists {
                break
            } else if nextButton.exists {
                nextButton.tap()
                expectation(for: exists, evaluatedWith: checkResultButton, handler: nil)
                waitForExpectations(timeout: 5, handler: nil)
            } else {
                XCTFail("Expected 'Next Round' button or 'Game Over' text to appear")
            }
        }
        
        XCTAssertTrue(app.staticTexts["Game Over"].exists, "Game Over screen should be displayed when score reaches zero")
    }
    
    func testRestartGameFromGameOver() throws {
        // First, reach the Game Over state
        try testGameOver()
        
        let restartButton = app.buttons["Restart"]
        XCTAssertTrue(restartButton.exists, "Restart button should exist on Game Over screen")
        
        restartButton.tap()
        
        // Verify that the game has reset
        let startButton = app.buttons["Start Game"]
        XCTAssertTrue(startButton.exists, "Start Game button should exist after restarting")
        
        XCTAssertTrue(app.staticTexts["Score: 0"].exists, "Score should be reset to 0")
    }
    @MainActor
    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            let app = XCUIApplication()
            measure(metrics: [
                XCTApplicationLaunchMetric(),
                XCTCPUMetric(application: app),
                XCTMemoryMetric(application: app)
            ]) {
                app.launch()
            }
        }
    }
    
}
