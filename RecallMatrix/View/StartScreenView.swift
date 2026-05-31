//
//  StartScreenView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftUI

struct StartScreenView: View {
  @Environment(\.openWindow) private var openWindow
  @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
  @AppStorage("HighestScore") private var highestScore = 0
  @State private var isShowingStats = false
  @State private var isShowingAwards = false

  var body: some View {
    NavigationStack {
      ZStack {
        MatrixBackgroundView()

        ScrollView {
          VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 16) {
              Image(systemName: "square.grid.3x3.square")
                .font(.largeTitle)
                .foregroundStyle(MatrixTheme.accentGradient)
                .accessibilityHidden(true)

              Text("Recall Matrix")
                .font(.largeTitle.bold())
                .foregroundStyle(MatrixTheme.ink)
                .multilineTextAlignment(.leading)

              Text("Memorize the signal, rebuild the pattern, and keep the streak alive as the matrix grows.")
                .font(.title3)
                .foregroundStyle(MatrixTheme.mutedInk)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 44)

            HStack(spacing: 12) {
              MatrixStatusPillView(title: "Best", value: highestScore.formatted(), systemImage: "crown.fill", tint: MatrixTheme.warning)
              MatrixStatusPillView(title: "Mode", value: "Timed", systemImage: "timer", tint: MatrixTheme.accent)
            }

            VStack(spacing: 12) {
              NavigationLink {
                ContentView()
              } label: {
                Label("Enter Game", systemImage: "play.fill")
              }
              .buttonStyle(MatrixActionButtonStyle())
              .accessibilityIdentifier("EnterGameButton")

              NavigationLink {
                OnboardingView()
              } label: {
                Label("How to Play", systemImage: "questionmark.circle")
              }
              .buttonStyle(.bordered)
              .tint(MatrixTheme.accent)
              .accessibilityIdentifier("HowToPlayButton")
            }
            .matrixPanel()

            StartScreenQuickActionsView(
              isShowingStats: $isShowingStats,
              isShowingAwards: $isShowingAwards
            )
          }
          .frame(maxWidth: 620, alignment: .leading)
          .padding()
        }
      }
      .navigationBarBackButtonHidden(true)
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItemGroup(placement: .automatic) {
          Button("Stats", systemImage: "chart.xyaxis.line") {
            isShowingStats.toggle()
          }
          .labelStyle(.iconOnly)

          Button("Awards", systemImage: "rosette") {
            isShowingAwards.toggle()
          }
          .labelStyle(.iconOnly)

          NavigationLink {
            SettingsView()
          } label: {
            Label("Settings", systemImage: "gearshape")
          }
          .labelStyle(.iconOnly)
          .accessibilityIdentifier("SettingsButton")
        }
      }
      .sheet(isPresented: $isShowingAwards) {
        AwardsView()
      }
      .sheet(isPresented: $isShowingStats) {
        StatsView()
      }
    }
    .platform(for: .macOS) { $0.frame(minWidth: 600, minHeight: 540) }
    .onAppear {
      #if os(macOS)
      if !hasSeenOnboarding {
        openWindow(id: "OnboardingWindow")
        hasSeenOnboarding = true
      }
      #endif
    }
  }
}
