//
//  DataModel.swift
//  MemoryMatrix
//
//  Created by Gerard Gomez on 9/15/24.
//

import AVFoundation
import Observation
import SwiftUI

@Observable
@MainActor
final class DataModel {
    @ObservationIgnored
    @AppStorage("SoundEnabled") private var soundEnabled = true
    @ObservationIgnored
    @AppStorage("HapticFeedback") private var hapticFeedbackEnabled = true

    var gridSize = 3
    var tiles: [Tile] = []
    var gameState: GameState = .start
    var score = 0
    private let patternDisplayDuration: UInt64 = 1_500_000_000

    var highlightedTileIndices: Set<Int> = []
    var roundCount = 1
    var lastRoundCorrect = false
    
    // Timer Properties
    var timerDuration: Int = 30 // Default value, can be updated from Settings
    var remainingTime: Int = 30
    var timerTask: Task<Void, Never>? = nil
    
    func startNewRound() {
        if lastRoundCorrect {
            roundCount += 1
            gridSize = min(gridSize + 1, 6)
        } else {
            gridSize = max(gridSize - 1, 3)
        }
        generatetiles()
        gameState = .showingPattern
        Task {
            try await Task.sleep(nanoseconds: patternDisplayDuration)
            hidePattern()
        }
    }
    
    private func generatetiles() {
        tiles = (0..<(gridSize * gridSize)).map { Tile(id: $0 )}
        highlightedTileIndices.removeAll()
        
        let numberOfTilesToHighlight = Int.random(in: 1...(gridSize * gridSize) / 2)
        
        while highlightedTileIndices.count < numberOfTilesToHighlight {
            highlightedTileIndices.insert(Int.random(in: 0..<tiles.count))
        }
        for index in highlightedTileIndices {
            tiles[index].isHighlighted = true
        }
    }
    
    private func hidePattern() {
        for index in tiles.indices {
            tiles[index].isHighlighted = false
        }
        gameState = .userInput
        startTimer()
    }
    func selectTile(at index: Int) {
        guard gameState == .userInput else { return }
        tiles[index].isSelected.toggle()
        if soundEnabled {
            AudioManager.shared.playSound("titleTap.wav")
            
        }
        if hapticFeedbackEnabled {
            HapticManager.shared.generateFeedback(for: .selection)
        }
    }
    
    func checkResult() {
        timerTask?.cancel()
        gameState = .result
        let userSelections = Set(tiles.indices.filter { tiles[$0].isSelected })
        
        for index in tiles.indices {
            if highlightedTileIndices.contains(index) {
                if tiles[index].isSelected {
                    tiles[index].isCorrectTile = true
                } else {
                    tiles[index].isMissed = true
                }
            } else if tiles[index].isSelected {
                tiles[index].isIncorrectTile = true
            }
        }
        if userSelections == highlightedTileIndices {
            score += 1
            lastRoundCorrect = true
            if soundEnabled {
                AudioManager.shared.playSound("correct.wav")
            }
            if hapticFeedbackEnabled {
                HapticManager.shared.generateFeedback(for: .success)
            }
        } else {
            score = max(score - 1, 0)
            lastRoundCorrect = false
            if soundEnabled {
                AudioManager.shared.playSound("incorrect.wav")
            }
            if hapticFeedbackEnabled {
                HapticManager.shared.generateFeedback(for: .error)
            }
        }
    }
    
    func gameOver() {
        timerTask?.cancel()
        gameState = .gameOver
        if soundEnabled {
            AudioManager.shared.playSound("gameOver.wav")
        }
        if hapticFeedbackEnabled {
            HapticManager.shared.generateFeedback(for: .error)
        }
    }
    func resetGame() {
        score = 0
        roundCount = 1
        gridSize = 3
        tiles.removeAll()
        gameState = .start
        remainingTime = timerDuration
        timerTask?.cancel()
    }
    // Timer Functions
    private func startTimer() {
        remainingTime = timerDuration
        timerTask?.cancel()
        timerTask = Task {
            do {
                while remainingTime > 0 {
                    try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second
                    remainingTime -= 1
                }
                if gameState == .userInput {
                    gameOver()
                }
            } catch {
                // Handle the cancellation or other errors if necessary
                // For CancellationError, you can simply ignore it
            }
        }
    }

    
    func updateTimerDuration(_ newDuration: Int) {
        timerDuration = newDuration
        remainingTime = newDuration
    }
}
