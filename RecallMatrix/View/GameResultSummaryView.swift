//
//  GameResultSummaryView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct GameResultSummaryView: View {
  var lastRoundCorrect: Bool
  var currentStreak: Int
  var correctTileCount: Int
  var totalHighlighted: Int
  var nextRound: () -> Void

  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: lastRoundCorrect ? "checkmark.seal.fill" : "arrow.counterclockwise")
        .font(.largeTitle)
        .foregroundStyle(lastRoundCorrect ? MatrixTheme.success : MatrixTheme.warning)
        .accessibilityHidden(true)

      Text(lastRoundCorrect ? "Pattern matched" : "Pattern missed")
        .font(.title2.bold())
        .foregroundStyle(MatrixTheme.ink)

      Text("\(correctTileCount)/\(totalHighlighted) tiles correct")
        .font(.headline.monospacedDigit())
        .foregroundStyle(MatrixTheme.mutedInk)

      if lastRoundCorrect && currentStreak >= 2 {
        Label("Streak \(currentStreak)", systemImage: "flame.fill")
          .font(.headline)
          .foregroundStyle(MatrixTheme.warning)
      }

      Button("Next Round", systemImage: "arrow.right", action: nextRound)
        .buttonStyle(MatrixActionButtonStyle())
    }
    .accessibilityElement(children: .combine)
  }
}
