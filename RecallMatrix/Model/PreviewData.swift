//
//  PreviewData.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation
import SwiftData
import SwiftUI

struct PreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let schema = Schema([GameSession.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let gameSessions = GameSession.examples
        
        gameSessions.forEach { container.mainContext.insert($0) }
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .environment(GameModel())
            .environment(MetricModel())
            .modelContainer(context)
    }
}
