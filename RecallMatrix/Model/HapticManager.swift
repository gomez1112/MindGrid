//
//  HapticManager.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import Foundation

#if canImport(UIKit) && !os(visionOS)
import UIKit

/// Manages haptic feedback across the app.
@MainActor
class HapticManager {
    static let shared = HapticManager()
    
    /// Generates haptic feedback based on the specified type.
    /// - Parameter type: The type of haptic feedback to generate.
    func generateFeedback(for type: HapticFeedbackType) {
        switch type {
            case .selection:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            case .success, .warning, .error:
                let generator = UINotificationFeedbackGenerator()
                switch type {
                    case .success:
                        generator.notificationOccurred(.success)
                    case .warning:
                        generator.notificationOccurred(.warning)
                    case .error:
                        generator.notificationOccurred(.error)
                    default:
                        break
                }
        }
    }
}

#else

class HapticManager {
    @MainActor static let shared = HapticManager()
    func generateFeedback(for type: HapticFeedbackType) {
        // Haptic feedback not supported on this platform
    }
}

#endif

enum HapticFeedbackType {
    case selection
    case success
    case warning
    case error
}

