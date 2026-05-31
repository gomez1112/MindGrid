//
//  StatsChartsGridView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct StatsChartsGridView: View {
  var metric: MetricModel
  var sessions: [GameSession]

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text("Trends")
        .font(.title2.bold())
        .foregroundStyle(MatrixTheme.ink)

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 14)], spacing: 14) {
        ChartCard(title: "Accuracy over time") {
          AccuracyChart(metric: metric, sessions: sessions)
        }

        ChartCard(title: "Grid size over time") {
          GridSizeChart(metric: metric, sessions: sessions)
        }

        ChartCard(title: "Time per game") {
          TimeChart(metric: metric, sessions: sessions)
        }

        ChartCard(title: "Games played") {
          GamesPlayedChart(metric: metric, sessions: sessions)
        }
      }
    }
  }
}
