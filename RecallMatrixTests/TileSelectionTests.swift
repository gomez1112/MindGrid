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
        try await Task.sleep(for: .seconds(2.8))
        
        if model.gameState == .userInput {
            let indexToSelect = 0
            model.selectTile(at: indexToSelect)
            #expect(model.tiles[indexToSelect].isSelected == true)
        }
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
        try await Task.sleep(for: .seconds(2.8))
        
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
        #expect(model.score == max(previousScore - 1, 0))
        #expect(model.lastRoundCorrect == false)
        
        // Verify tile states
        for (index, tile) in model.tiles.enumerated() {
            if !model.highlightedTileIndices.contains(index) && tile.isSelected {
                #expect(tile.isIncorrectTile == true)
            }
        }
    }
}

