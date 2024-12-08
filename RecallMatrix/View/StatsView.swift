//
//  StatsView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftData
import SwiftUI

struct StatsView: View {
    @Query private var sessions: [GameSession]
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack(spacing: 30) {
                Text("Your performance")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    .padding(.top, 40)
                
                if overallGamesPlayed == 0 {
                    ContentUnavailableView("No game sessions recorded yet.", systemImage: "brain.head.profile")
                } else {
                    VStack(spacing: 20) {
                        statsCard(icon: "gamecontroller.fill", title: "Games Played", value: overallGamesPlayed.formatted())
                        accuracyCard
                        statsCard(icon: "grid.circle.fill", title: "Avg. Grid Size", value: formattedGridSize)
                        statsCard(icon: "clock.fill", title: "Avg. Time", value: formattedTime)
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
        .navigationTitle("Stats")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    @ViewBuilder
    private func statsCard(icon: String, title: String, value: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(value)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding()
        }
        .frame(height: 90)
        .transition(.opacity.combined(with: .scale))
    }
    
    @ViewBuilder
    private var accuracyCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "target")
                        .font(.title2)
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    
                    Text("Average Accuracy")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                Text(formattedAccuracy)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                
                ProgressView(value: averageAccuracy)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .accessibilityLabel("Average Accuracy")
                    .accessibilityValue(formattedAccuracy)
            }
            .padding()
        }
        .frame(height: 120)
        .transition(.opacity.combined(with: .scale))
    }
    var averageAccuracy: Double {
        guard !sessions.isEmpty else { return 0 }
        let totalAccuracy = sessions.reduce(0.0) { $0 + $1.accuracy }
        return totalAccuracy / Double(sessions.count)
    }
    var averageGridSize: Double {
        guard !sessions.isEmpty else { return 0 }
        let totalGridSize = sessions.reduce(0) { $0 + $1.gridSize }
        return Double(totalGridSize) / Double(sessions.count)
    }
    var averageTime: Double {
        guard !sessions.isEmpty else { return 0 }
        let totalTime = sessions.reduce(0.0) { $0 + $1.elapsedTime }
        return Double(totalTime) / Double(sessions.count)
    }
    var overallGamesPlayed: Int {
        sessions.count
    }
    private var formattedAccuracy: String {
        (averageAccuracy * 100).formatted(.number.precision(.fractionLength(1))) + "%"
    }
    
    private var formattedGridSize: String {
        averageGridSize.formatted(.number.precision(.fractionLength(1))) + "x" +
        averageGridSize.formatted(.number.precision(.fractionLength(1)))
    }
    
    private var formattedTime: String {
        averageTime.formatted(.number.precision(.fractionLength(1))) + " sec"
    }
}

#Preview {
    StatsView()
}
