//
//  AwardsView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import SwiftData
import SwiftUI

struct AwardsView: View {
    @Query(sort: \GameSession.date) private var sessions: [GameSession]
    @Environment(GameModel.self) private var model
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAward = Award.award
    @State private var isShowingAwardDetails = false
    #if os(watchOS)
    private var columns = Array(repeating: GridItem(.adaptive(minimum: 40, maximum: 60)), count: 3)
    #else
    private var columns = Array(repeating: GridItem(.flexible()), count: 4)
    #endif
    private var awardTitle: String {
        model.hasEarnedAward(context: context, award: selectedAward, sessions: sessions) ? "Unlocked: \(selectedAward.name)" : "Locked"
    }
    var body: some View {
        NavigationStack {
            awardsGrid
                .navigationTitle("Awards")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss", action: dismiss.callAsFunction)
                    }
                }
                .alert(awardTitle, isPresented: $isShowingAwardDetails) {
                    
                } message: {
                    Text(selectedAward.description)
                }
                .platform(for: .macOS) { $0.frame(minWidth: 600, minHeight: 500) }
        }
    }
    private var awardsGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(Award.awards) { award in
                    AwardButtonView(award: award, selectedAward: $selectedAward, isShowingDetails: $isShowingAwardDetails)
                        .padding()
                }
            }
        }
        .contentMargins(.all, 10)
    }
}

#Preview(traits: .previewData) {
    AwardsView()
}
