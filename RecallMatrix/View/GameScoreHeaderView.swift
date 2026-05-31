//
//  GameScoreHeaderView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct GameScoreHeaderView: View {
  var score: Int
  var highestScore: Int
  var roundCount: Int
  var gridSize: Int
  var currentStreak: Int

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: 6) {
          Text("Current run")
            .font(.caption)
            .foregroundStyle(MatrixTheme.mutedInk)
          Text(score.formatted())
            .font(.system(.largeTitle, design: .rounded).bold().monospacedDigit())
            .foregroundStyle(MatrixTheme.ink)
            .contentTransition(.numericText())
        }

        Spacer()

        MatrixStatusPillView(title: "Best", value: highestScore.formatted(), systemImage: "crown.fill", tint: MatrixTheme.warning)
      }

      HStack(spacing: 10) {
        MatrixStatusPillView(title: "Round", value: roundCount.formatted(), systemImage: "flag.checkered", tint: MatrixTheme.accent)
        MatrixStatusPillView(title: "Board", value: "\(gridSize)x\(gridSize)", systemImage: "square.grid.3x3", tint: MatrixTheme.mutedInk)

        if currentStreak >= 2 {
          MatrixStatusPillView(title: "Streak", value: currentStreak.formatted(), systemImage: "flame.fill", tint: MatrixTheme.warning)
            .transition(.scale.combined(with: .opacity))
        }
      }
    }
    .matrixPanel()
    .animation(.snappy, value: currentStreak)
    .accessibilityElement(children: .contain)
  }
}
