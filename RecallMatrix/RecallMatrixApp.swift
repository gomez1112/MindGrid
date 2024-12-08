//
//  RecallMatrixApp.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/3/24.
//

import SwiftUI

@main
struct RecallMatrixApp: App {
    @State private var model = DataModel()
    var body: some Scene {
        WindowGroup {
            StartScreenView()
        }
        .environment(model)
    }
}
