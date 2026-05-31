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
        let isUnlocked = game.hasEarnedAward(context: context, award: award, sessions: sessions)
        Button {
            selectedAward = award
            isShowingDetails = true
        } label: {
            VStack(spacing: 12) {
                Image(systemName: award.image)
                    .font(.largeTitle)
                    .foregroundStyle(isUnlocked ? Color(award.color) : MatrixTheme.mutedInk.opacity(0.46))
                    .frame(height: 42)
                    .accessibilityHidden(true)

                Text(award.name)
                    .font(.headline)
                    .foregroundStyle(MatrixTheme.ink)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(isUnlocked ? "Unlocked" : "Locked")
                    .font(.caption)
                    .foregroundStyle(isUnlocked ? MatrixTheme.accent : MatrixTheme.mutedInk)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(MatrixTheme.surfaceRaised.opacity(isUnlocked ? 0.92 : 0.58), in: .rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isUnlocked ? MatrixTheme.accent.opacity(0.26) : MatrixTheme.separator, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(award.name), \(isUnlocked ? "unlocked" : "locked")")
    }
}
