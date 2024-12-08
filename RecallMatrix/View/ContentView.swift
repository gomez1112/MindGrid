//
//  ContentView.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataModel.self) private var model
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    var startImmediately = false
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                GridView()
                    .navigationTitle("Recall Matrix")
            }
            .onAppear {
                if startImmediately {
                    model.startNewRound()
                }
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
        .environment(DataModel())
}
