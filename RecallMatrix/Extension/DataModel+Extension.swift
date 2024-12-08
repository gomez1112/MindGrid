//
//  DataModel+Extension.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation
import SwiftData

extension GameModel {
    
    // MARK: - Awards
    func hasEarnedAward(context: ModelContext, award: Award, sessions: [GameSession]) -> Bool {
        guard !sessions.isEmpty else { return false }
        switch award.criterion {
            case .sessions:
                return sessions.count >= award.value
            case .accuracy:
                let totalAccuracy = sessions.reduce(0.0) { $0 + $1.accuracy }
                let averageAccuracy = (totalAccuracy / Double(sessions.count)) * 100.0
                return averageAccuracy >= Double(award.value)
            case .time:
                return sessions.contains { $0.elapsedTime <= Double(award.value)}
            case .gridSize:
                return sessions.contains { $0.gridSize >= award.value }
        }
    }
}
