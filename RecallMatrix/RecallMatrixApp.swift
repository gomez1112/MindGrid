//
//  RecallMatrixApp.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/3/24.
//

import SwiftData
import SwiftUI

@main
struct RecallMatrixApp: App {
    @State private var model = GameModel()
    var body: some Scene {
        WindowGroup {
            StartScreenView()
        }
        .modelContainer(ModelContainer.createContainer)
        .environment(model)
        
        #if os(macOS)
        Window("Onboarding", id: "OnboardingWindow") {
            OnboardingView()
        }
        #endif
    }
}
