//
//  MindGridApp.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

@main
struct MindGridApp: App {
    @State private var model = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(model)
    }
}
