//
//  HapticManager.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import Foundation

#if canImport(UIKit)
import UIKit

@MainActor
class HapticManager {
    static let shared = HapticManager()
    
    func generateFeedback(for type: HapticFeedbackType) {
        DispatchQueue.main.async {
            switch type {
                case .selection:
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                case .success:
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                case .warning:
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                case .error:
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
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

