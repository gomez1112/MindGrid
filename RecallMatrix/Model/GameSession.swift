//
//  GameSession.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import Foundation
import SwiftData

@Model
final class GameSession {
    var date: Date
    var score: Int
    var gridSize: Int
    var correctTiles: Int
    var totalTiles: Int
    var elapsedTime: TimeInterval
    
    init(date: Date, score: Int, gridSize: Int, correctTiles: Int, totalTiles: Int, elapsedTime: TimeInterval) {
        self.date = date
        self.score = score
        self.gridSize = gridSize
        self.correctTiles = correctTiles
        self.totalTiles = totalTiles
        self.elapsedTime = elapsedTime
    }
    
    var accuracy: Double {
        totalTiles == 0 ? 0.0 : Double(correctTiles) / Double(totalTiles)
    }
    
    @MainActor static let examples: [GameSession] = [
        GameSession(date: Date().addingTimeInterval(-60*60*24*3), score: 100, gridSize: 4, correctTiles: 4, totalTiles: 16, elapsedTime: 10.0),
        GameSession(date: Date().addingTimeInterval(-60*60*24*2), score: 200, gridSize: 8, correctTiles: 30, totalTiles: 64, elapsedTime: 20.0),
        GameSession(date: Date().addingTimeInterval(-60*60*24), score: 300, gridSize: 16, correctTiles: 200, totalTiles: 256, elapsedTime: 30.0),
        GameSession(date: Date(), score: 400, gridSize: 32, correctTiles: 32, totalTiles: 512, elapsedTime: 40.0),
    ]
}
