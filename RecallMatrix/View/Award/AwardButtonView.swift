//
//  AwardButtonView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import SwiftData
import SwiftUI

struct AwardButtonView: View {
    @Environment(GameModel.self) private var game
    @Environment(\.modelContext) private var context
    @Query(sort: \GameSession.date) private var sessions: [GameSession]
    let award: Award
    @Binding var selectedAward: Award
    @Binding var isShowingDetails: Bool
    var body: some View {
        Button {
            selectedAward = award
            isShowingDetails = true
        } label: {
            Image(systemName: award.image)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(game.hasEarnedAward(context: context, award: award, sessions: sessions) ? Color(award.color) : Color.gray)
        }
        .buttonStyle(.borderless)
    }
}

#Preview(traits: .previewData) {
    AwardButtonView(award: .award, selectedAward: .constant(.award), isShowingDetails: .constant(true))
}
