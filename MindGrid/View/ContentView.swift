//
//  ContentView.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .red.opacity(0.1), .blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                GridView()
                    .navigationTitle("Memory Matrix")
            }
            #if os(macOS)
            .sheet(isPresented: .constant(!hasSeenOnboarding)) {
                OnboardingView()
            }
            #else
            .fullScreenCover(isPresented: .constant(!hasSeenOnboarding)) {
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
