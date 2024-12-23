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
            .sheet(isPresented: Binding(
                get: { !hasSeenOnboarding},
                set: { hasSeenOnboarding = !$0 }
            )) {
                OnboardingView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(GameModel())
}
