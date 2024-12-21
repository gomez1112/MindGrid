//
//  StartScreenView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftUI

struct StartScreenView: View {
    @State private var isShowingStats = false
    @State private var isShowingAwards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                gradientBackground
                
                // Main Content
                VStack(spacing: 40) {
                    // Game Title
                    VStack {
                        Text("Recall Matrix")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(Constant.Style.blueToPurple)
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
                        NavigationLink(destination: ContentView()) {
                            Text("Enter Game")
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
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .frame(maxWidth: 600)
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isShowingAwards) {
                AwardsView()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingStats.toggle()
                    } label: {
                        Image(systemName: "chart.pie")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingAwards.toggle()
                    } label: {
                        Label("Show awards", systemImage: "rosette")
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
            .environment(GameModel())
    }
}
