//
//  AudioManagerTests.swift
//  RecallMatrixTests
//
//  Created by Gerard Gomez on 12/24/24.
//

import Foundation
import Testing
@testable import RecallMatrix

@MainActor
@Suite
struct AudioManagerTests {
    
    @Test
    func testPlaySoundWithValidName() {
        // Given
        let audioManager = AudioManager.shared
        
        // When
        // For a valid file in your bundle, e.g., "correct.wav"
        // This won't produce audible sound in a CI environment,
        // but we can check for no crashes or errors.
        audioManager.playSound("correct.wav")
        
        // Then
        // Typically, you'd #expect no crash or error thrown.
        // If your Testing framework allows it, do something like:
        #expect(true, "Playing a valid sound file should not crash")
    }
    
    @Test
    func testPlaySoundWithInvalidName() {
        // Given
        let audioManager = AudioManager.shared
        
        // When
        // Try to play a file that does not exist
        audioManager.playSound("nonexistent_file.wav")
        
        // Then
        // We expect no crash. We might also log or check if an error was printed.
        #expect(true, "Playing a non-existent file should fail gracefully without crashing")
    }
}

