//
//  Untitled.swift
//  MemoryMatrix
//
//  Created by Gerard Gomez on 12/1/24.
//

import XCTest
@testable import RecallMatrix

@MainActor
final class RecallMatrixPerformanceTests: XCTestCase {
    
    // MARK: - Properties
    var model: DataModel!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        try super.setUpWithError()
        model = DataModel()
    }
    
    override func tearDownWithError() throws {
        model = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceStartNewRound() throws {
        measure {
            // Simulate a new round
            model.lastRoundCorrect = true
            model.startNewRound()
        }
    }
    
    func testPerformanceCheckResult() throws {
        // Setup
        model.startNewRound()
        // Simulate user selecting tiles
        for index in 0..<model.tiles.count {
            model.selectTile(at: index)
        }
        
        measure {
            // Check result performance
            model.checkResult()
        }
    }
    
    func testPerformanceSelectTile() throws {
        // Setup
        model.startNewRound()
        
        measure {
            // Measure performance of selecting tiles
            for index in 0..<model.tiles.count {
                model.selectTile(at: index)
            }
        }
    }
}
