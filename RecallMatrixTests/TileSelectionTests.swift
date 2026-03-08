//
//  TileSelectionTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Testing
@testable import RecallMatrix

@MainActor
struct TileSelectionTests {
    
    var model: GameModel!
    
    init() {
        model = GameModel()
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
        model.hidePattern()
        
        let highlightedTiles = model.tiles.filter { $0.isHighlighted }
        #expect(highlightedTiles.isEmpty)
        #expect(model.gameState == .userInput)
    }
    
    @Test
    func testSelectTile() async throws {
        model.startNewRound()
        model.hidePattern()
        
        #expect(model.gameState == .userInput)
        let indexToSelect = 0
        model.selectTile(at: indexToSelect)
        #expect(model.tiles[indexToSelect].isSelected == true)
    }
    
    @Test
    func testTileSelectionDuringInvalidState() {
        model.startNewRound()
        model.gameState = .showingPattern
        model.selectTile(at: 0)
        
        #expect(model.tiles[0].isSelected == false)
    }
    
    @Test
    func testCheckResultCorrectSelection() async throws {
        model.startNewRound()
        model.hidePattern()
        
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
        model.hidePattern()
        
        // Select a non-highlighted tile
        for (index, _) in model.tiles.enumerated() {
            if !model.highlightedTileIndices.contains(index) {
                model.selectTile(at: index)
                break
            }
        }
        
        let previousScore = model.score
        model.checkResult()
        
        #expect(model.gameState == .result)
        #expect(model.score == previousScore) // Score unchanged on wrong answer
        #expect(model.lastRoundCorrect == false)
        #expect(model.currentStreak == 0)
        
        // Verify tile states
        for (index, tile) in model.tiles.enumerated() {
            if !model.highlightedTileIndices.contains(index) && tile.isSelected {
                #expect(tile.isIncorrectTile == true)
            }
        }
    }
    
    @Test
    func testStreakIncrementsOnCorrect() {
        model.startNewRound()
        model.hidePattern()
        
        // Select all highlighted tiles
        for index in model.highlightedTileIndices {
            model.selectTile(at: index)
        }
        model.checkResult()
        
        #expect(model.currentStreak == 1)
        #expect(model.bestStreak == 1)
        #expect(model.totalCorrectRounds == 1)
        #expect(model.score == 1)
    }
    
    @Test
    func testStreakResetsOnIncorrect() {
        model.startNewRound()
        model.hidePattern()
        
        // First, get a correct answer to build streak
        for index in model.highlightedTileIndices {
            model.selectTile(at: index)
        }
        model.checkResult()
        #expect(model.currentStreak == 1)
        
        // Now get an incorrect answer
        model.startNewRound()
        model.hidePattern()
        for (index, _) in model.tiles.enumerated() {
            if !model.highlightedTileIndices.contains(index) {
                model.selectTile(at: index)
                break
            }
        }
        model.checkResult()
        
        #expect(model.currentStreak == 0)
        #expect(model.bestStreak == 1) // Best streak preserved
        #expect(model.score == 1) // Score unchanged on wrong answer
    }
}

