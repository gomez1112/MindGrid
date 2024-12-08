//
//  StartScreenView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftUI

struct StartScreenView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var isShowingStats = false
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                GradientBackgroundView()
                
                // Main Content
                VStack(spacing: 40) {
                    // Game Title
                    VStack {
                        Text("Recall Matrix")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                        
                        Text("Test Your Memory. Challenge Your Limits.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Decorative Animation (Optional)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 100))
                        .foregroundStyle(.purple)
                        .padding(.bottom, 10)
                        .animation(.spring(), value: true)
                    
                    // Navigation Buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: ContentView(startImmediately: true)) {
                            Text("Start Game")
                                .buttonBackground()
                        }
                        NavigationLink(destination: OnboardingView()) {
                            Text("How to Play")
                                .buttonBackground()
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .buttonBackground()
                        }
                        NavigationLink(destination: LeaderBoardView()) {
                            Text("Leaderboard")
                                .buttonBackground()
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .frame(maxWidth: 600) // Constrain width for larger screens
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingStats.toggle()
                    } label: {
                        Image(systemName: "chart.pie")
                    }
                }
            }
            .sheet(isPresented: $isShowingStats) {
                StatsView()
            }
        }
    }
}



#Preview {
    NavigationStack {
        StartScreenView()
            .environment(DataModel())
    }
}
