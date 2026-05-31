//
//  StartScreenQuickActionsView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct StartScreenQuickActionsView: View {
  @Binding var isShowingStats: Bool
  @Binding var isShowingAwards: Bool

  var body: some View {
    HStack(spacing: 12) {
      Button("Stats", systemImage: "chart.xyaxis.line") {
        isShowingStats.toggle()
      }
      .buttonStyle(.bordered)
      .tint(MatrixTheme.accent)

      Button("Awards", systemImage: "rosette") {
        isShowingAwards.toggle()
      }
      .buttonStyle(.bordered)
      .tint(MatrixTheme.warning)

      NavigationLink {
        SettingsView()
      } label: {
        Label("Settings", systemImage: "gearshape")
      }
      .buttonStyle(.bordered)
      .tint(MatrixTheme.mutedInk)
    }
    .controlSize(.large)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
