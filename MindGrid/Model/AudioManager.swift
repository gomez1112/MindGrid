//
//  AudioManager.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import AVFoundation
import Foundation
#if canImport(AppKit)
import AppKit
#endif

@MainActor
final class AudioManager {
   static let shared = AudioManager()
   private var audioPlayer: AVAudioPlayer?
    
    func playSound(_ sounName: String) {
        #if os(macOS)
        if let url = Bundle.main.url(forResource: sounName, withExtension: nil) {
            NSSound(contentsOf: url, byReference: false)?.play()
        }
        #else
        guard let url = Bundle.main.url(forResource: sounName, withExtension: nil) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
        #endif
    }
}

