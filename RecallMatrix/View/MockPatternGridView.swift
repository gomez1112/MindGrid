//
//  MockPatternGridView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct MockPatternGridView: View {
  var mockHighlightedTiles: [Bool]
  var isGreenPhase: Bool

  var body: some View {
    VStack(spacing: 14) {
      Text(isGreenPhase ? "Correct tiles selected" : "Remember the signal")
        .font(.headline)
        .foregroundStyle(isGreenPhase ? MatrixTheme.success : MatrixTheme.warning)

      Grid(horizontalSpacing: 10, verticalSpacing: 10) {
        ForEach(0..<3, id: \.self) { row in
          GridRow {
            ForEach(0..<3, id: \.self) { column in
              Rectangle()
                .fill(tileColor(for: row * 3 + column))
                .aspectRatio(1, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 12))
            }
          }
        }
      }
    }
  }

  private func tileColor(for index: Int) -> Color {
    if mockHighlightedTiles[index] {
      return isGreenPhase ? MatrixTheme.success : MatrixTheme.warning
    }

    return MatrixTheme.gridBase
  }
}
