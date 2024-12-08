//
//  LeaderBoardView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftData
import SwiftUI

struct LeaderBoardView: View {
    @Query(sort: [SortDescriptor(\GameSession.score, order: .reverse)]) private var sessions: [GameSession]
    var body: some View {
        List {
            ForEach(sessions) { session in
                VStack(alignment: .leading) {
                    Text("Score: \(session.score)")
                        .font(.headline)
                    Text("Date: \(session.date.formatted())")
                        .font(.subheadline)
                    Text("Grid Size: \(session.gridSize)x\(session.gridSize)")
                        .font(.footnote)
                    Text("Accuracy: \((session.accuracy * 100).formatted())%")
                        .font(.footnote)
                }
            }
        }
        .navigationTitle("Leaderboard")
    }
}

#Preview {
    NavigationStack {
        LeaderBoardView()
            .environment(DataModel())
    }
}
