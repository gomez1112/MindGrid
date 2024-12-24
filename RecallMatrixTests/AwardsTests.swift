//
//  AwardsTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Foundation
import SwiftData
import Testing
@testable import RecallMatrix


@MainActor
struct AwardsTests {
    var model: GameModel!
    
    init() {
        model = GameModel()
    }
    let awards = Award.awards
    
    @Test
    func awardsLoadCorrectly() {
        #expect(!awards.isEmpty, "Failed to load awards from JSON.")
    }
    
    @Test
    func awardIDMatchesName() {
        for award in awards {
            #expect(award.id == award.name, "Award ID \(award.id) does not match name \(award.name).")
        }
    }
    
    @Test
    func newUserHasUnlockedNoAwards() throws {
        for award in awards {
            #expect(!model.hasEarnedAward(context: ModelContainer.createContainer.mainContext, award: award, sessions: []), "New user has unlocked \(award.name).")
        }
    }
    
    @Test(arguments: [1, 10, 50, 100] )
    func playingGamesUnlockAwards(numberOfGames: Int) {
        let sessionsAward = Award(name: "Frequent Player", description: "Play \(numberOfGames) or more sessions", color: "blue", criterion: .sessions, value: numberOfGames, image: "rosette")
        var sessions: [GameSession] = []
        
        for _ in 0..<numberOfGames {
            let session = GameSession(date: .now, score: 0, gridSize: 3, correctTiles: 0, totalTiles: 0, elapsedTime: 0)
            sessions.append(session)
        }
        let isEarned = model.hasEarnedAward(context: ModelContainer.createContainer.mainContext, award: sessionsAward, sessions: sessions)
        #expect(isEarned,
                """
                For \(numberOfGames) session(s), \
                expected to earn award: \(true). \
                Got: \(isEarned)
                """)
        
    }
    
    @Test(arguments: [1, 10, 50, 100] )
    func playingGamesDoesNotUnlockAwards(numberOfGames: Int) {
        let sessionsAward = Award(name: "Frequent Player", description: "Play \(numberOfGames) or more sessions", color: "blue", criterion: .sessions, value: numberOfGames, image: "rosette")
        var sessions: [GameSession] = []
        
        for _ in 0..<numberOfGames - 1 {
            let session = GameSession(date: .now, score: 0, gridSize: 3, correctTiles: 0, totalTiles: 0, elapsedTime: 0)
            sessions.append(session)
        }
        let isEarned = model.hasEarnedAward(context: ModelContainer.createContainer.mainContext, award: sessionsAward, sessions: sessions)
        #expect(!isEarned,
                """
                For \(numberOfGames) session(s), \
                expected to earn award: \(true). \
                Got: \(isEarned)
                """)
        
    }
    @Test(arguments: [90, 95, 100] )
    func testAccuracy(accuracy: Int) {
        let sessionsAward = Award(name: "Aim", description: "Achieve an accuracy of \(accuracy)", color: "blue", criterion: .accuracy, value: accuracy, image: "target")
        var sessions: [GameSession] = []
        
        for _ in 0..<accuracy {
            let session = GameSession(date: .now, score: 0, gridSize: 3, correctTiles: accuracy, totalTiles: 100, elapsedTime: 0)
            sessions.append(session)
        }
        let isEarned = model.hasEarnedAward(context: ModelContainer.createContainer.mainContext, award: sessionsAward, sessions: sessions)
        #expect(isEarned,
                """
                For \(accuracy)%, \
                expected to earn award: \(true). \
                Got: \(isEarned)
                """)
        
    }
}
