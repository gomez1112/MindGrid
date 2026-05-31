//
//  GamePhaseControlView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct GamePhaseControlView: View {
  var gameState: GameState
  var countdownValue: Int
  var paused: Bool
  var lastRoundCorrect: Bool
  var currentStreak: Int
  var correctTileCount: Int
  var totalHighlighted: Int
  var useLargeControls: Bool
  var start: () -> Void
  var checkResult: () -> Void
  var togglePause: () -> Void

  var body: some View {
    VStack(spacing: 14) {
      switch gameState {
      case .start:
        Button("Start Game", systemImage: "play.fill", action: start)
          .buttonStyle(MatrixActionButtonStyle())
          .controlSize(useLargeControls ? .large : .regular)
          .accessibilityIdentifier("Start Game")
      case .countdown:
        CountdownOverlayView(value: countdownValue)
      case .userInput:
        Button(paused ? "Resume" : "Pause", systemImage: paused ? "play.fill" : "pause.fill", action: togglePause)
          .buttonStyle(.bordered)
          .tint(MatrixTheme.accent)
          .accessibilityIdentifier("PauseResumeButton")

        Button("Check Result", systemImage: "checkmark.seal.fill", action: checkResult)
          .buttonStyle(MatrixActionButtonStyle())
          .controlSize(useLargeControls ? .large : .regular)
      case .result:
        GameResultSummaryView(
          lastRoundCorrect: lastRoundCorrect,
          currentStreak: currentStreak,
          correctTileCount: correctTileCount,
          totalHighlighted: totalHighlighted,
          nextRound: start
        )
      default:
        EmptyView()
      }
    }
    .matrixPanel()
  }
}
