//
//  StatsMetricsGridView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct StatsMetricsGridView: View {
  var metric: MetricModel
  var sessions: [GameSession]

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text("Key metrics")
        .font(.title2.bold())
        .foregroundStyle(MatrixTheme.ink)

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 12)], spacing: 12) {
        MatrixMetricTileView(title: "Games played", value: metric.overallGamesPlayed(sessions: sessions).formatted(), systemImage: "gamecontroller.fill", tint: MatrixTheme.accent)
        MatrixMetricTileView(title: "Avg. grid", value: metric.formattedGridSize(sessions: sessions), systemImage: "square.grid.3x3", tint: MatrixTheme.mutedInk)
        MatrixMetricTileView(title: "Avg. time", value: metric.formattedTime(sessions: sessions), systemImage: "clock.fill", tint: MatrixTheme.warning)
        MatrixMetricTileView(title: "Avg. accuracy", value: metric.formattedAccuracy(sessions: sessions), systemImage: "target", tint: MatrixTheme.success)
        MatrixMetricTileView(title: "Perfect rounds", value: metric.perfectRoundsCount(sessions: sessions).formatted(), systemImage: "checkmark.seal.fill", tint: MatrixTheme.success)
      }
    }
  }
}
