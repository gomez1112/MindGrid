//
//  DynamicDifficultyView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct DynamicDifficultyView: View {
  var gridSize: Int
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    VStack(spacing: 14) {
      MatrixStatusPillView(title: "Current board", value: "\(gridSize)x\(gridSize)", systemImage: "square.grid.3x3", tint: MatrixTheme.accent)

      Grid(horizontalSpacing: 4, verticalSpacing: 4) {
        ForEach(0..<gridSize, id: \.self) { _ in
          GridRow {
            ForEach(0..<gridSize, id: \.self) { _ in
              Rectangle()
                .foregroundStyle(MatrixTheme.accent.opacity(0.58))
                .aspectRatio(1, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 4))
            }
          }
        }
      }
      .animation(reduceMotion ? .none : .smooth(duration: 1.5), value: gridSize)
    }
  }
}
