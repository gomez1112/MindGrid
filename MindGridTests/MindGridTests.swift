//
//  MindGridTests.swift
//  MindGridTests
//
//  Created by Gerard Gomez on 12/1/24.
//

import Testing
@testable import MindGrid

@MainActor
struct MemoryMatrixTests {
    
    // MARK: - Properties
    var model: DataModel!
    
    init() {
        model = DataModel()
    }
    
    // MARK: - Tests
    
    @Test
    func testInitialState() {
        // Verify initial state of DataModel
        #expect(model.gridSize == 3)
        #expect(model.tiles.isEmpty)
        #expect(model.gameState == .start)
        #expect(model.score == 0)
        #expect(model.roundCount == 1)
        #expect(model.lastRoundCorrect == false)
    }
    
    @Test
    func testStartNewRoundIncrementsRound() {
        model.lastRoundCorrect = true
        let previousRoundCount = model.roundCount
        model.startNewRound()
        
        #expect(model.roundCount == previousRoundCount + 1)
        #expect(model.gridSize == 4) // Since gridSize increases by 1
        #expect(model.gameState == .showingPattern)
        #expect(!model.tiles.isEmpty)
    }
    
    @Test
    func testStartNewRoundDecrementsGridSize() {
        model.lastRoundCorrect = false
        model.gridSize = 4
        model.startNewRound()
        
        #expect(model.roundCount == 1) // Should not increment
        #expect(model.gridSize == 3) // Decremented gridSize
        #expect(model.gameState == .showingPattern)
        #expect(!model.tiles.isEmpty)
    }
    
    @Test
    func testGenerateTiles() {
        model.startNewRound()
        
        let expectedTileCount = model.gridSize * model.gridSize
        #expect(model.tiles.count == expectedTileCount)
        
        let highlightedTiles = model.tiles.filter { $0.isHighlighted }
        #expect(!highlightedTiles.isEmpty)
        #expect(highlightedTiles.count <= expectedTileCount / 2)
    }
    
    @Test
    func testHidePattern() async throws {
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_800_000_000) // Wait for pattern to hide
        
        let highlightedTiles = model.tiles.filter { $0.isHighlighted }
        #expect(highlightedTiles.isEmpty)
        #expect(model.gameState == .userInput)
    }
    
    @Test
    func testSelectTile() async throws {
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        let indexToSelect = 0
        model.selectTile(at: indexToSelect)
        
        #expect(model.tiles[indexToSelect].isSelected == true)
    }
    
    @Test
    func testCheckResultCorrectSelection() async throws {
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        // Select all highlighted tiles
        for (index, _) in model.tiles.enumerated() {
            if model.highlightedTileIndices.contains(index) {
                model.selectTile(at: index)
            }
        }
        
        model.checkResult()
        
        #expect(model.gameState == .result)
        #expect(model.score == 1)
        #expect(model.lastRoundCorrect == true)
        
        // Verify tile states
        for (index, tile) in model.tiles.enumerated() {
            if model.highlightedTileIndices.contains(index) {
                #expect(tile.isCorrectTile == true)
            }
        }
    }
    
    @Test
    func testCheckResultIncorrectSelection() async throws {
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        // Select non-highlighted tiles
        for (index, _) in model.tiles.enumerated() {
            if !model.highlightedTileIndices.contains(index) {
                model.selectTile(at: index)
                break // Select only one incorrect tile
            }
        }
        
        let previousScore = model.score
        model.checkResult()
        
        #expect(model.gameState == .result)
        #expect(model.score == max(previousScore - 1, 0))
        #expect(model.lastRoundCorrect == false)
        
        // Verify tile states
        for (index, tile) in model.tiles.enumerated() {
            if !model.highlightedTileIndices.contains(index) && tile.isSelected {
                #expect(tile.isIncorrectTile == true)
            }
        }
    }
    
    @Test
    func testGameOver() {
        model.score = 0
        model.gameOver()
        
        #expect(model.gameState == .gameOver)
    }
    
    @Test
    func testResetGame() {
        model.score = 5
        model.roundCount = 3
        model.gridSize = 5
        model.tiles = [Tile(id: 0), Tile(id: 1)]
        model.gameState = .result
        
        model.resetGame()
        
        #expect(model.score == 0)
        #expect(model.roundCount == 1)
        #expect(model.gridSize == 3)
        #expect(model.tiles.isEmpty)
        #expect(model.gameState == .start)
    }
    
    @Test
    func testGridSizeLimits() {
        model.lastRoundCorrect = true
        model.gridSize = 6
        model.startNewRound()
        
        #expect(model.gridSize == 6) // Should not exceed 6
        
        model.lastRoundCorrect = false
        model.gridSize = 3
        model.startNewRound()
        
        #expect(model.gridSize == 3) // Should not go below 3
    }
    
    @Test
    func testTileSelectionDuringInvalidState() {
        model.startNewRound()
        model.gameState = .showingPattern
        model.selectTile(at: 0)
        
        #expect(model.tiles[0].isSelected == false)
    }
    
    @Test
    func testTimerStartsOnUserInput() async throws {
        model.timerDuration = 5
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        #expect(model.gameState == .userInput)
        #expect(model.remainingTime == model.timerDuration)
        
        // Wait a second and check if remaining time decreased
        try await Task.sleep(nanoseconds: 1_100_000_000)
        #expect(model.remainingTime == model.timerDuration - 1)
    }
    
    @Test
    func testTimerDecrementsCorrectly() async throws {
        model.timerDuration = 3
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        // Wait for the timer to count down to zero
        try await Task.sleep(nanoseconds: 3_500_000_000) // Wait 3.5 seconds
        #expect(model.remainingTime == 0)
        #expect(model.gameState == .gameOver)
    }
    
    @Test
    func testGameOverWhenTimerExpires() async throws {
        model.timerDuration = 2
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        // Wait for the timer to expire
        try await Task.sleep(nanoseconds: 2_500_000_000) // Wait 2.5 seconds
        #expect(model.gameState == .gameOver)
    }
    
    @Test
    func testTimerCancelsOnCheckResult() async throws {
        model.timerDuration = 5
        model.startNewRound()
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        // Simulate user clicking "Check Result" before timer expires
        try await Task.sleep(nanoseconds: 2_000_000_000) // Wait 2 seconds
        model.checkResult()
        #expect(model.gameState == .result)
        
        // Wait additional time to see if timer has stopped
        let remainingTimeAfterCheck = model.remainingTime
        try await Task.sleep(nanoseconds: 3_000_000_000) // Wait 3 seconds
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
        try await Task.sleep(nanoseconds: 1_600_000_000) // Wait for pattern to hide
        
        // Simulate some time passing
        try await Task.sleep(nanoseconds: 5_000_000_000) // Wait 5 seconds
        model.resetGame()
        #expect(model.remainingTime == model.timerDuration)
        #expect(model.timerTask == nil || model.timerTask?.isCancelled == true)
    }
    
    @Test
    func testTimerDoesNotRunInOtherGameStates() async throws {
        model.timerDuration = 5
        
        // In "start" state
        #expect(model.gameState == .start)
        #expect(model.timerTask == nil)
        
        // Start new round
        model.startNewRound()
        #expect(model.gameState == .showingPattern)
        #expect(model.timerTask == nil)
        
        // Wait for pattern to hide
        try await Task.sleep(nanoseconds: 1_600_000_000)
        #expect(model.gameState == .userInput)
        #expect(model.timerTask != nil)
        
        // Check result to move to "result" state
        model.checkResult()
        #expect(model.gameState == .result)
        #expect(model.timerTask == nil || model.timerTask?.isCancelled == true)
    }
}
