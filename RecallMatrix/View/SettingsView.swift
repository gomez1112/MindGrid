//
//  SettingsView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    @AppStorage("TimerDuration") private var timerDuration = 30
    @AppStorage("SoundEnabled") private var soundEnabled = true
    @AppStorage("HapticFeedback") private var hapticFeedbackEnabled = true
    @State private var isShowingResetConfirmation = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section("Game Settings") {
                    Stepper(value: $timerDuration, in: 1...30) {
                        HStack {
                            Text("Time per Round")
                            Spacer()
                            Text("^[\(timerDuration) second](inflect: true)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityLabel("Time per Round")
                    .accessibilityValue("^[\(timerDuration) second](inflect: true)")
                    Toggle("Enable Sound", isOn: $soundEnabled)
                        .accessibilityLabel("Enable Sound")
                        .accessibilityHint("Toggle to enable or disable all game sounds.")
                    Toggle("Enable Haptic Feedback", isOn: $hapticFeedbackEnabled)
                        .accessibilityLabel("Enable Haptic Feedback")
                        .accessibilityHint("Toggle to enable or disable haptic vibrations.")
                }
                Section {
                    NavigationLink(destination: OnboardingView()) {
                        HStack {
                            Spacer()
                            Text("Show Onboarding Again")
                                .foregroundStyle(Constant.Style.blueToPurple)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .tint(.accentColor)
                    .accessibilityLabel("Show Onboarding Again")
                    .accessibilityHint("Show the initial instructions for playing the game.")
                }
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                }
                Section {
                    Button {
                        isShowingResetConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Reset Settings")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Reset Settings")
                    .accessibilityHint("Reset all game settings to their defaults.")
                }
            }
            .alert("Reset Settings", isPresented: $isShowingResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive, action: resetSettings)
            } message: {
                Text("Are you sure you want to reset all settings to default?")
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .accessibilityLabel("Settings Screen")
            .accessibilityElement(children: .contain)
            .platform(for: .macOS) { $0.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
              }
            }
        }
    }
    private func resetSettings() {
        timerDuration = 30
        soundEnabled = true
        hapticFeedbackEnabled = true
    }
}

#Preview {
    SettingsView()
        .environment(GameModel())
}

