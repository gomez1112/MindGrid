//
//  SettingsView.swift
//  MemoryMatrix
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    @AppStorage("TimerDuration") private var timerDuration = 3
    @AppStorage("SoundEnabled") private var soundEnabled = true
    @AppStorage("HapticFeedback") private var hapticFeedbackEnabled = true

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
                    Text("1.1.1")
                        .foregroundStyle(.secondary)
                }
            }
            Section {
                Button(action: resetSettings) {
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
        .formStyle(.grouped)
        .navigationTitle("Settings")
    }
    private func resetSettings() {
        timerDuration = 3
        soundEnabled = true
        hapticFeedbackEnabled = true
    }
}

#Preview {
    SettingsView()
}

