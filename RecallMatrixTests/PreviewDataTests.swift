//
//  PreviewDataTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Foundation
import SwiftData
import SwiftUI
import Testing
@testable import RecallMatrix


@MainActor
struct PreviewDataTests {
    
    @Test
    func testMakeSharedContext() async throws {
        // Given/When
        let container = try await PreviewData.makeSharedContext()
        
        // Confirm the example sessions were inserted
        // You can do this if your test has read/write access to container.mainContext:
        let fetchRequest = FetchDescriptor<GameSession>()
        let sessions = try container.mainContext.fetch(fetchRequest)
        
        // The code in PreviewData inserts `GameSession.examples`, which has 4 items
        #expect(sessions.count == 4, "Expected 4 example sessions in the in-memory container.")
    }
}
