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
}
