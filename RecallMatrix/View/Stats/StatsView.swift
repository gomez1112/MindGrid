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
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @State private var metric = MetricModel()
    @Query(sort: [SortDescriptor(\GameSession.date)]) private var sessions: [GameSession]
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                ScrollView {
                    VStack(spacing: 30) {
                        headerTitle
                            .padding(.top, 40)
                        
                        if metric.overallGamesPlayed(sessions: sessions) == 0 {
                            ContentUnavailableView("No game sessions recorded yet.", systemImage: "chart.xyaxis.line")
                        } else {
                            
                            contentSection
                        }
                        Spacer()
                    }
                    .padding(.horizontal, metric.horizontalPadding)
                }
            }
            .navigationTitle("Stats")
#if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close, action: dismiss.callAsFunction)
                }
            }
        }
    }
    private var headerTitle: some View {
        Text("Your performance")
            .font(.title.bold())
            .foregroundStyle(Constant.Style.blueToPurple)
        
    }
    private var contentSection: some View {
        VStack(spacing: 20) {
            metricsSection
                .padding(.top)
            chartsSection
                .padding(.top)
        }
    }

    private var chartsSection: some View {
        VStack(alignment: .leading) {
            Text("Performance Trends")
                .font(.title2.bold())
            
            let columns: [GridItem] = [
                GridItem(.adaptive(minimum: 400), spacing: 20),
            ]
            
            LazyVGrid(columns: columns, spacing: 20) {
                // 1. Accuracy Over Time
                ChartCard(title: "Accuracy Over Time") {
                    AccuracyChart(metric: metric, sessions: sessions)
                }
                
                // 2. Grid Size Over Time
                ChartCard(title: "Grid Size Over Time") {
                    GridSizeChart(metric: metric, sessions: sessions)
                }
                
                // 3. Time Per Game
                ChartCard(title: "Time Per Game") {
                    TimeChart(metric: metric, sessions: sessions)
                }
                
                // 4. Games Played Over Time
                ChartCard(title: "Games Played Over Time") {
                    GamesPlayedChart(metric: metric, sessions: sessions)
                }
            }
        }
    }
    private var metricsSection: some View {
        VStack(alignment: .leading) {
            Text("Key Metrics")
                .font(.title2.bold())
            HStack {
                metricCard(title: "Games Played", value: metric.overallGamesPlayed(sessions: sessions).formatted(), icon: "gamecontroller.fill")
                metricCard(title: "Avg. Grid Size", value: metric.formattedGridSize(sessions: sessions), icon: "grid.circle.fill")
            }
            HStack {
                metricCard(title: "Avg. Time", value: metric.formattedTime(sessions: sessions), icon: "clock.fill")
                metricCard(title: "Avg. Accuracy", value: metric.formattedAccuracy(sessions: sessions), icon: "target")
            }
        }
    }
    private func metricCard(title: LocalizedStringKey, value: String, icon: String) -> some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(Constant.Style.blueToPurple)
                Spacer()
                Text(value)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorSchemeContrast == .increased
                      ? AnyShapeStyle(Color(.systemBackground).opacity(0.9))
                      : AnyShapeStyle(.ultraThinMaterial))
        }
        .overlay {
            if colorSchemeContrast == .increased {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

#Preview("English", traits: .previewData) {
    StatsView()
}
#Preview("Spanish", traits: .previewData) {
    StatsView()
        .environment(\.locale, .init(identifier: "es"))
}
#Preview("Dynamic Variants", traits: .previewData) {
    StatsView()
        .environment(\.dynamicTypeSize, .xxxLarge)
}
