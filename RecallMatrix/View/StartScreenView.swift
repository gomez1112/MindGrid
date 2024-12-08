//
//  StartScreenView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftUI

struct StartScreenView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .red.opacity(0.1), .blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
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
                    }
                }
                .padding()
                .frame(maxWidth: 600) // Constrain width for larger screens
            }
        }
    }
}



#Preview {
    StartScreenView()
        .environment(DataModel())
}
