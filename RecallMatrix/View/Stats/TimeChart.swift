//
//  TimeChart.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Charts
import SwiftUI

struct TimeChart: View {
    let metric: MetricModel
    let sessions: [GameSession]
    var body: some View {
        Chart {
            ForEach(sessions) { session in
                LineMark(
                    x: .value("Date", session.date),
                    y: .value("Time (sec)", session.elapsedTime)
                )
                .lineStyle(StrokeStyle(lineWidth: metric.lineWidth))
                .foregroundStyle(.pink)
                #if os(visionOS)
                .symbol(Circle().strokeBorder(lineWidth: metric.lineWidth))
                #endif
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
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text("\((value.as(Double.self) ?? 0), format: .number) s")
                }
            }
        }
    }
}

#Preview {
    TimeChart(metric: MetricModel(), sessions: GameSession.examples)
}
