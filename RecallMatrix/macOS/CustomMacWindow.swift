//
//  CustomMacWindow.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/22/24.
//

import SwiftUI

/// A reusable macOS window scene that applies a consistent style/configuration.
struct CustomMacWindow<Content: View>: Scene {
    /// The window title displayed in the title bar.
    let title: String
    /// A unique identifier for this window scene.
    let id: String
    /// The content view builder.
    @ViewBuilder let content: () -> Content
    
    var body: some Scene {
        Window(title, id: id) {
            content()
                .toolbar(removing: .title)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.thickMaterial, for: .window)
                .windowMinimizeBehavior(.disabled)
                .presentedWindowStyle(.titleBar)
                .presentedWindowToolbarStyle(.unified)
        }
        .defaultSize(width: 600, height: 500)
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
        .defaultLaunchBehavior(.suppressed)
    }
}
