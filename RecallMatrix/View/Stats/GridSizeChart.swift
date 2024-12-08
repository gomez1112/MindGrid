//
//  GridSizeChart.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Charts
import SwiftUI

struct GridSizeChart: View {
    let metric: MetricModel
    let sessions: [GameSession]
    
    var body: some View {
        Chart {
            ForEach(sessions) { session in
                LineMark(
                    x: .value("Date", session.date),
                    y: .value("Grid Size", session.gridSize)
                )
                .lineStyle(StrokeStyle(lineWidth: metric.lineWidth))
                .foregroundStyle(.blue)
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
            AxisMarks()
        }
    }
}

#Preview {
    GridSizeChart(metric: MetricModel(), sessions: GameSession.examples)
}
