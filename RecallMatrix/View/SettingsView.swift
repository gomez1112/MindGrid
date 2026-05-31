//
//  SettingsView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
  @AppStorage("SoundEnabled") private var soundEnabled = true
  @AppStorage("HapticFeedback") private var hapticFeedbackEnabled = true
  @AppStorage("HighestScore") private var highestScore = 0
  @AppStorage("TimerDuration") private var timerDuration = 30
  @State private var isShowingResetConfirmation = false
  @State private var isShowingOnboarding = false
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ZStack {
        MatrixBackgroundView()

        ScrollView {
          VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
              Text("Settings")
                .font(.largeTitle.bold())
                .foregroundStyle(MatrixTheme.ink)
              Text("Tune the session length, feedback, and saved progress.")
                .font(.headline)
                .foregroundStyle(MatrixTheme.mutedInk)
            }
            .padding(.top)

            VStack(spacing: 18) {
              Stepper(value: $timerDuration, in: 1...30) {
                HStack {
                  Label("Time per round", systemImage: "timer")
                  Spacer()
                  Text("^[\(timerDuration) second](inflect: true)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(MatrixTheme.accent)
                }
              }
              .accessibilityValue("^[\(timerDuration) second](inflect: true)")

              Toggle("Enable sound", systemImage: "speaker.wave.2.fill", isOn: $soundEnabled)
                .accessibilityHint("Toggle to enable or disable all game sounds.")

              Toggle("Enable haptic feedback", systemImage: "hand.tap.fill", isOn: $hapticFeedbackEnabled)
                .accessibilityHint("Toggle to enable or disable haptic vibrations.")
            }
            .tint(MatrixTheme.accent)
            .matrixPanel()

            VStack(spacing: 12) {
              Button("Show onboarding again", systemImage: "questionmark.circle") {
                hasSeenOnboarding = false
                isShowingOnboarding = true
              }
              .buttonStyle(.bordered)
              .tint(MatrixTheme.accent)

              Button("Clear high score", systemImage: "crown.slash") {
                highestScore = 0
              }
              .buttonStyle(.bordered)
              .tint(MatrixTheme.warning)

              Button("Reset settings", systemImage: "arrow.counterclockwise") {
                isShowingResetConfirmation = true
              }
              .buttonStyle(MatrixActionButtonStyle(role: .destructive))
            }
            .controlSize(.large)
            .matrixPanel()

            HStack {
              Text("Version")
                .foregroundStyle(MatrixTheme.mutedInk)
              Spacer()
              Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                .font(.headline.monospacedDigit())
                .foregroundStyle(MatrixTheme.ink)
            }
            .matrixPanel()
            .accessibilityElement(children: .combine)
          }
          .frame(maxWidth: 620, alignment: .leading)
          .padding()
        }
      }
      .navigationTitle("Settings")
      #if !os(macOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .toolbarBackground(.hidden, for: .navigationBar)
      .alert("Reset Settings", isPresented: $isShowingResetConfirmation) {
        Button("Cancel", role: .cancel) {}
        Button("Reset", role: .destructive, action: resetSettings)
      } message: {
        Text("Are you sure you want to reset all settings to default?")
      }
      .sheet(isPresented: $isShowingOnboarding) {
        OnboardingView()
      }
      .platform(for: .macOS) { view in
        view.toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Dismiss", action: dismiss.callAsFunction)
          }
        }
      }
    }
  }

  private func resetSettings() {
    timerDuration = 30
    soundEnabled = true
    hapticFeedbackEnabled = true
    highestScore = 0
    hasSeenOnboarding = false
  }
}
