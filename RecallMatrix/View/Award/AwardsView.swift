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
  private var columns = Array(repeating: GridItem(.adaptive(minimum: 44, maximum: 64), spacing: 12), count: 3)
  #else
  private var columns = [GridItem(.adaptive(minimum: 132), spacing: 12)]
  #endif

  private var awardTitle: String {
    model.hasEarnedAward(context: context, award: selectedAward, sessions: sessions) ? "Unlocked: \(selectedAward.name)" : "Locked"
  }

  var body: some View {
    NavigationStack {
      ZStack {
        MatrixBackgroundView()

        ScrollView {
          VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
              Text("Awards")
                .font(.largeTitle.bold())
                .foregroundStyle(MatrixTheme.ink)
              Text("Milestones for accuracy, speed, volume, and larger boards.")
                .font(.headline)
                .foregroundStyle(MatrixTheme.mutedInk)
            }
            .padding(.top)

            LazyVGrid(columns: columns, spacing: 12) {
              ForEach(Award.awards) { award in
                AwardButtonView(award: award, selectedAward: $selectedAward, isShowingDetails: $isShowingAwardDetails)
              }
            }
          }
          .frame(maxWidth: 720, alignment: .leading)
          .padding()
        }
      }
      .navigationTitle("Awards")
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(role: .close, action: dismiss.callAsFunction)
        }
      }
      .alert(awardTitle, isPresented: $isShowingAwardDetails) {
      } message: {
        Text(selectedAward.description)
      }
      .platform(for: .macOS) { $0.frame(minWidth: 600, minHeight: 500) }
    }
  }
}
