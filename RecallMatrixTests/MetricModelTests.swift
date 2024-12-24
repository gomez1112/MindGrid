//
//  MetricModelTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Foundation
import Testing
@testable import RecallMatrix

@MainActor
struct MetricModelTests {
    
    var metric = MetricModel()
    
    @Test
    func testOverallGamesPlayed() {
        // Given
        let sessions = [
            GameSession(date: Date(), score: 10, gridSize: 3, correctTiles: 5, totalTiles: 10, elapsedTime: 30),
            GameSession(date: Date(), score: 5,  gridSize: 4, correctTiles: 4, totalTiles: 10, elapsedTime: 25)
        ]
        
        // When
        let count = metric.overallGamesPlayed(sessions: sessions)
        
        // Then
        #expect(count == 2, "We provided 2 sessions, so overallGamesPlayed should be 2.")
    }
    
    @Test
    func testFormattedAccuracy() {
        // Given
        let sessions = [
            // 50% accuracy
            GameSession(date: Date(), score: 0, gridSize: 3, correctTiles: 1, totalTiles: 2, elapsedTime: 10),
            // 100% accuracy
            GameSession(date: Date(), score: 0, gridSize: 3, correctTiles: 4, totalTiles: 4, elapsedTime: 20)
        ]
        // average accuracy = (0.50 + 1.00) / 2 = 0.75 (i.e. 75%)
        
        // When
        let formatted = metric.formattedAccuracy(sessions: sessions)
        
        // Then
        #expect(formatted == "75.0%", "Expected average accuracy ~75.0%. Got: \(formatted)")
    }
    
    @Test
    func testFormattedGridSize() {
        // Given
        let sessions = [
            GameSession(date: Date(), score: 10, gridSize: 3, correctTiles: 2, totalTiles: 9, elapsedTime: 15),
            GameSession(date: Date(), score: 20, gridSize: 5, correctTiles: 10, totalTiles: 25, elapsedTime: 25)
        ]
        // average grid size = (3 + 5) / 2 = 4.0
        
        // When
        let formattedSize = metric.formattedGridSize(sessions: sessions)
        
        // Then
        // Typically "4.0 x 4.0" if fractionLength(1)
        #expect(formattedSize == "4.0 x 4.0", "Expected average grid size to be 4.0 x 4.0")
    }
    
    @Test
    func testCountsByDay() {
        // Given
        // Let's create multiple sessions on the same day, plus different days
        let day1 = Calendar.current.startOfDay(for: Date()) // e.g. today's date at midnight
        let day2 = day1.addingTimeInterval(-86_400)         // 1 day prior
        let sessions = [
            GameSession(date: day1, score: 0, gridSize: 3, correctTiles: 1, totalTiles: 2, elapsedTime: 10),
            GameSession(date: day1.addingTimeInterval(3600), score: 0, gridSize: 3, correctTiles: 2, totalTiles: 4, elapsedTime: 15),
            GameSession(date: day2, score: 0, gridSize: 3, correctTiles: 5, totalTiles: 10, elapsedTime: 20)
        ]
        
        // When
        let dayCounts = metric.countsByDay(sessions: sessions)
        
        // Then
        // dayCounts is an array of tuples (day: Date, count: Int) sorted by day.
        // Expect 2 sessions on day1, 1 session on day2
        #expect(dayCounts.count == 2, "We have 2 distinct days.")
        let firstEntry = dayCounts.first!
        let secondEntry = dayCounts.last!
        
        // Because day2 is older than day1, it should come first in sorted order
        #expect(firstEntry.day == day2, "Oldest day (day2) should come first in sorted array.")
        #expect(firstEntry.count == 1, "One session on day2.")
        
        #expect(secondEntry.day == day1, "Next day should be day1.")
        #expect(secondEntry.count == 2, "Two sessions on day1.")
    }
}

