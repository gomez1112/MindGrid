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
                            .font(.largeTitle.bold())
                            .platformNot(for: .visionOS) {
                                $0.foregroundStyle(Constant.Style.blueToPurple)
                            }
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
                        .accessibilityIdentifier("StartScreenSettingsButton")
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
                
                ToolbarItem(placement: .automatic) {
                    Button {
                        isShowingStats.toggle()
                    } label: {
                        Image(systemName: "chart.pie")
                    }
                }
                #if !os(visionOS)
                ToolbarSpacer(.fixed)
                #endif
                ToolbarItem(placement: .automatic) {
                    Button {
                        isShowingAwards.toggle()
                    } label: {
                        Label("Show awards", systemImage: "rosette")
                    }
                }
                #if !os(visionOS)
                ToolbarSpacer(.fixed)
                #endif
                ToolbarItem(placement: .automatic) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $isShowingStats) {
                StatsView()
            }
        }
        .platform(for: .macOS) { $0.frame(minWidth: 600, minHeight: 500)}
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



#Preview(traits: .previewData) {
    NavigationStack {
        StartScreenView()
            .environment(GameModel())
    }
}
