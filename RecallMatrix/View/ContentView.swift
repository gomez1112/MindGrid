//
//  ContentView.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(GameModel.self) private var game
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                GridView()
                    .navigationTitle("Recall Matrix")
            }
            #if os(macOS)
            .sheet(isPresented: .constant(!hasSeenOnboarding)) {
                OnboardingView()
            }
            #else
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { !hasSeenOnboarding },
                set: { if !$0 { hasSeenOnboarding = true
                }})) {
                    OnboardingView()
                }
            #endif
        }
    }
}

#Preview {
    ContentView()
        .environment(GameModel())
}
