//
//  OnboardingStepView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct OnboardingStepView: View {
  var currentStep: Int
  var mockHighlightedTiles: [Bool]
  var gridSize: Int
  var isGreenPhase: Bool
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      if currentStep == 1 {
        Text("Memorize the highlighted tiles.")
          .font(.title2.bold())
          .foregroundStyle(MatrixTheme.ink)
        Text("The board shows a short pattern. Keep the positions in memory.")
          .font(.headline)
          .foregroundStyle(MatrixTheme.mutedInk)
        MockPatternGridView(mockHighlightedTiles: mockHighlightedTiles, isGreenPhase: isGreenPhase)
      } else if currentStep == 2 {
        Text("Rebuild the pattern.")
          .font(.title2.bold())
          .foregroundStyle(MatrixTheme.ink)
        Text("Tap the tiles you remember. Correct rounds increase the board size, missed rounds ease it back.")
          .font(.headline)
          .foregroundStyle(MatrixTheme.mutedInk)
        DynamicDifficultyView(gridSize: gridSize)
      } else {
        Text("Beat the timer.")
          .font(.title2.bold())
          .foregroundStyle(MatrixTheme.ink)
        Text("Submit before time runs out. A streak earns extra points.")
          .font(.headline)
          .foregroundStyle(MatrixTheme.mutedInk)
        Image(systemName: "timer")
          .symbolEffect(.rotate, options: .nonRepeating, isActive: !reduceMotion)
          .font(.system(.largeTitle, design: .rounded).bold())
          .foregroundStyle(MatrixTheme.accentGradient)
          .frame(maxWidth: .infinity)
          .accessibilityLabel("Countdown timer")
      }
    }
  }
}
