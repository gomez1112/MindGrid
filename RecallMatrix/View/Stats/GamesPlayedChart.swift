//
//  GamesPlayedChart.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Charts
import SwiftUI

struct GamesPlayedChart: View {
    let metric: MetricModel
    let sessions: [GameSession]
    var body: some View {
        Chart {
            ForEach(metric.countsByDay(sessions: sessions), id: \.day) { entry in
                BarMark(
                    x: .value("Date", entry.day),
                    y: .value("Count", entry.count)
                )
                .foregroundStyle(.orange)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartYAxis {
            AxisMarks()
        }
    }
}

#Preview {
    GamesPlayedChart(metric: MetricModel(), sessions: GameSession.examples)
}
