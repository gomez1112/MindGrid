//
//  StatsView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import Charts
import SwiftData
import SwiftUI

struct StatsView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var metric = MetricModel()
  @Query(sort: [SortDescriptor(\GameSession.date)]) private var sessions: [GameSession]

  var body: some View {
    NavigationStack {
      ZStack {
        MatrixBackgroundView()

        ScrollView {
          VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
              Text("Performance")
                .font(.largeTitle.bold())
                .foregroundStyle(MatrixTheme.ink)
              Text("Recent games, accuracy, board growth, and pace.")
                .font(.headline)
                .foregroundStyle(MatrixTheme.mutedInk)
            }
            .padding(.top)

            if metric.overallGamesPlayed(sessions: sessions) == 0 {
              ContentUnavailableView("No game sessions recorded yet.", systemImage: "chart.xyaxis.line")
                .foregroundStyle(MatrixTheme.mutedInk)
                .matrixPanel()
            } else {
              StatsMetricsGridView(metric: metric, sessions: sessions)
              StatsChartsGridView(metric: metric, sessions: sessions)
            }
          }
          .frame(maxWidth: 980, alignment: .leading)
          .padding(.horizontal, metric.horizontalPadding)
          .padding(.vertical)
        }
      }
      .navigationTitle("Stats")
      #if os(iOS) || os(visionOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(role: .close, action: dismiss.callAsFunction)
        }
      }
    }
  }
}
