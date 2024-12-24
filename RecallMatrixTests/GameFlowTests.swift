//
//  GameFlowTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Testing
@testable import RecallMatrix

@MainActor
struct GameFlowTests {
    
    // MARK: - Properties
    var model: GameModel!
    
    init() {
        model = GameModel()
    }
    
    @Test
    func testInitialState() {
        #expect(model.gridSize == 3)
        #expect(model.tiles.isEmpty)
        #expect(model.gameState == .start)
        #expect(model.score == 0)
        #expect(model.roundCount == 1)
        #expect(!model.lastRoundCorrect)
    }
    
    @Test
    func testStartNewRoundIncrementsRound() {
        model.lastRoundCorrect = true
        let previousRoundCount = model.roundCount
        model.startNewRound()
        
        #expect(model.roundCount == previousRoundCount + 1)
        #expect(model.gridSize == 4)
        #expect(model.gameState == .showingPattern)
        #expect(!model.tiles.isEmpty)
    }
    
    @Test
    func testStartNewRoundDecrementsGridSize() {
        model.lastRoundCorrect = false
        model.gridSize = 4
        model.startNewRound()
        
        #expect(model.roundCount == 1)
        #expect(model.gridSize == 3)
        #expect(model.gameState == .showingPattern)
        #expect(!model.tiles.isEmpty)
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
        model.gridSize = 10
        model.startNewRound()
        
        #expect(model.gridSize == 10)
        
        model.lastRoundCorrect = false
        model.gridSize = 3
        model.startNewRound()
        
        #expect(model.gridSize == 3)
    }
}

