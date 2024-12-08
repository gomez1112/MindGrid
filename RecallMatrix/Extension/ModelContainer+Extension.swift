//
//  ModelContainer+Extension.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation
import SwiftData

extension ModelContainer {
    static let createContainer: ModelContainer = {
        let schema = Schema([GameSession.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create model container: \(error.localizedDescription)")
        }
    }()
}
