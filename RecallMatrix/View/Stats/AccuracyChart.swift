//
//  AccuracyChart.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Charts
import SwiftUI

struct AccuracyChart: View {
    let metric: MetricModel
    let sessions: [GameSession]
    
    var body: some View {
        Chart {
            ForEach(metric.filterLastFiveDaysSessions(from: sessions)) { session in
                PointMark(
                    x: .value("Date", session.date),
                    y: .value("Accuracy", session.accuracy * 100)
                )
                .lineStyle(StrokeStyle(lineWidth: metric.lineWidth))
                .foregroundStyle(.green)
                #if os(visionOS)
                .symbol(Circle().strokeBorder(lineWidth: metric.lineWidth))
                #endif
            }
        }
        .chartYScale(domain: 0...100)
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
                    Text("\((value.as(Double.self) ?? 0), format: .number.precision(.fractionLength(0)))%")
                }
            }
        }
        .frame(minWidth: 200, minHeight: 250)
    }
}

#Preview(traits: .previewData) {
    AccuracyChart(metric: MetricModel(), sessions: GameSession.examples)
}
