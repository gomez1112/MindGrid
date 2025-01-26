//
//  MetricModel.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation
import Observation

@Observable
@MainActor final class MetricModel {
    func countsByDay(sessions: [GameSession]) -> [(day: Date, count: Int)] {
        Dictionary(grouping: sessions, by: { Calendar.current.startOfDay(for: $0.date) })
            .map { (day, sessions) in
                (day: day, count: sessions.count)
            }
            .sorted(by: { $0.day < $1.day })
    }
    func filterLastFiveDaysSessions(from sessions: [GameSession]) -> [GameSession] {
        let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
        return sessions.filter { $0.date >= fiveDaysAgo }
    }
    func last5DaysSessions(sessions: [GameSession]) -> [(day: Date, count: Int)] {
        countsByDay(sessions: filterLastFiveDaysSessions(from: sessions))
    }
    private func averageAccuracy(sessions: [GameSession]) -> Double {
        guard !sessions.isEmpty else { return 0 }
        let totalAccuracy = sessions.reduce(0.0) { $0 + $1.accuracy }
        return totalAccuracy / Double(sessions.count)
    }
    private func averageGridSize(sessions: [GameSession]) -> Double {
        guard !sessions.isEmpty else { return 0 }
        let totalGridSize = sessions.reduce(0) { $0 + $1.gridSize }
        return Double(totalGridSize) / Double(sessions.count)
    }
    private func averageTime(sessions: [GameSession]) -> Double {
        guard !sessions.isEmpty else { return 0 }
        let totalTime = sessions.reduce(0.0) { $0 + $1.elapsedTime }
        return Double(totalTime) / Double(sessions.count)
    }
    func overallGamesPlayed(sessions: [GameSession]) -> Int {
        sessions.count
    }
    func formattedAccuracy(sessions: [GameSession]) -> String {
        (averageAccuracy(sessions: sessions) * 100.0).formatted(.number.precision(.fractionLength(1))) + "%"
    }
    
    func formattedGridSize(sessions: [GameSession]) -> String {
        averageGridSize(sessions: sessions).formatted(.number.precision(.fractionLength(1))) + " x " +
        averageGridSize(sessions: sessions).formatted(.number.precision(.fractionLength(1)))
    }
    
    func formattedTime(sessions: [GameSession]) -> String {
        averageTime(sessions: sessions).formatted(.number.precision(.fractionLength(1))) + " sec"
    }
    var horizontalPadding: CGFloat {
        #if os(macOS)
        return 60
        #elseif os(iOS) || os(visionOS)
        return 20
        #else
        return 20
        #endif
    }
    
    var chartHeight: CGFloat {
        #if os(macOS)
        return 250
        #elseif os(visionOS)
        return 280
        #else // iOS
        return 200
        #endif
    }
    
    var chartMinimumWidth: CGFloat {
        #if os(macOS)
        return 300
        #elseif os(visionOS)
        return 300
        #else // iOS
        return 200
        #endif
    }
    
    var lineWidth: CGFloat {
        #if os(visionOS)
        return 3
        #else
        return 2
        #endif
    }
    var titleFontSize: CGFloat {
        #if os(macOS)
        return 30
        #elseif os(visionOS)
        return 32
        #else
        return 28
        #endif
    }
}
