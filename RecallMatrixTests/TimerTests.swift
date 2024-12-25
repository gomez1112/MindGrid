//
//  TimerTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Testing
@testable import RecallMatrix

@MainActor
struct TimerTests {
    
    var model: GameModel!
    
    init() {
        model = GameModel()
    }
    
    @Test
    func testTimerStartsOnUserInput() async throws {
        model.timerDuration = 5
        model.startNewRound()
        model.hidePattern()
        #expect(model.gameState == .userInput)
        #expect(model.remainingTime == 5)
        
        try await Task.sleep(for: .seconds(3))
        #expect(model.remainingTime == 4)
    }
    
    @Test
    func testTimerDecrementsCorrectly() async throws {
        model.timerDuration = 3
        model.startNewRound()
        model.hidePattern()
        try await Task.sleep(for: .seconds(5))
        #expect(model.remainingTime == 0)
        #expect(model.gameState == .gameOver)
    }
    
    @Test
    func testGameOverWhenTimerExpires() async throws {
        model.timerDuration = 2
        model.startNewRound()
        model.hidePattern()
        try await Task.sleep(for: .seconds(5))
        #expect(model.gameState == .gameOver)
    }
    
    @Test
    func testTimerCancelsOnCheckResult() async throws {
        model.timerDuration = 5
        model.startNewRound()
        model.hidePattern()
        try await Task.sleep(for: .seconds(2.8))
        
        // Simulate user clicking "Check Result"
        try await Task.sleep(for: .seconds(2))
        model.checkResult()
        #expect(model.gameState == .result)
        
        // Check if timer has stopped
        let remainingTimeAfterCheck = model.remainingTime
        try await Task.sleep(for: .seconds(3))
        #expect(model.remainingTime == remainingTimeAfterCheck)
    }
    
    @Test
    func testTimerUpdatesFromSettings() {
        let newTimerDuration = 10
        model.updateTimerDuration(newTimerDuration)
        #expect(model.timerDuration == newTimerDuration)
        #expect(model.remainingTime == newTimerDuration)
    }
    
    @Test
    func testResetGameResetsTimer() async throws {
        model.timerDuration = 20
        model.startNewRound()
        try await Task.sleep(for: .seconds(2.8))
        
        // Simulate some time passing
        try await Task.sleep(for: .seconds(5))
        model.resetGame()
        
        #expect(model.remainingTime == model.timerDuration)
        #expect(model.timerTask == nil || model.timerTask?.isCancelled == true)
    }
}

