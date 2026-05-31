//
//  GameOverSummaryView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct GameOverSummaryView: View {
  var score: Int
  var highestScore: Int
  var roundCount: Int
  var bestStreak: Int
  var totalCorrectRounds: Int
  var message: String
  var restart: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Run complete")
          .font(.largeTitle.bold())
          .foregroundStyle(MatrixTheme.ink)
        Text(message)
          .font(.headline)
          .foregroundStyle(MatrixTheme.mutedInk)
      }

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
        MatrixMetricTileView(title: "Final score", value: score.formatted(), systemImage: "number", tint: MatrixTheme.accent)
        MatrixMetricTileView(title: "Best score", value: highestScore.formatted(), systemImage: "crown.fill", tint: MatrixTheme.warning)
        MatrixMetricTileView(title: "Rounds", value: roundCount.formatted(), systemImage: "flag.checkered", tint: MatrixTheme.mutedInk)
        MatrixMetricTileView(title: "Best streak", value: bestStreak.formatted(), systemImage: "flame.fill", tint: MatrixTheme.warning)
        MatrixMetricTileView(title: "Correct rounds", value: totalCorrectRounds.formatted(), systemImage: "checkmark.seal.fill", tint: MatrixTheme.success)
      }

      HStack(spacing: 12) {
        Button("Restart", systemImage: "arrow.counterclockwise", action: restart)
          .buttonStyle(MatrixActionButtonStyle())
          .keyboardShortcut("r", modifiers: [.command])

        NavigationLink {
          StartScreenView()
        } label: {
          Label("Home", systemImage: "house")
        }
        .buttonStyle(.bordered)
        .tint(MatrixTheme.accent)
      }
    }
    .matrixPanel()
    .accessibilityElement(children: .contain)
  }
}
