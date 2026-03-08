//
//  Constants.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftUI
import Foundation

enum Constant {
    enum Style {
        static let blueToPurple = LinearGradient(colors: [Color.blue, Color.purple], startPoint: .leading, endPoint: .trailing)
    }
    
    enum Animation {
        static let countdownDuration: Double = 0.7
        static let patternDisplayDuration: Double = 1.5
    }
}
