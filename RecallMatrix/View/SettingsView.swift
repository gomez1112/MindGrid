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
    
    var body: some View {
        Form {
            Section("Game Settings") {
                Stepper(value: $timerDuration, in: 5...120, step: 2) {
                    HStack {
                        Text("Time per Round")
                        Spacer()
                        Text("\(timerDuration) seconds")
                            .foregroundStyle(.secondary)
                    }
                }
                Toggle("Enable Sound", isOn: $soundEnabled)
                Toggle("Enable Haptic Feedback", isOn: $hapticFeedbackEnabled)
            }
            Section {
                Button(action: {
                    hasSeenOnboarding = false
                }) {
                    HStack {
                        Spacer()
                        Text("Show Onboarding Again")
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(.secondary)
                }
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
    }
    private func resetSettings() {
        timerDuration = 30
        soundEnabled = true
        hapticFeedbackEnabled = true
    }
}

#Preview {
    SettingsView()
}

