//
//  MatrixTheme.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

enum MatrixTheme {
  static var backgroundTop: Color { Color(red: 0.05, green: 0.07, blue: 0.08) }
  static var backgroundBottom: Color { Color(red: 0.10, green: 0.12, blue: 0.12) }
  static var surface: Color { Color(red: 0.13, green: 0.15, blue: 0.15) }
  static var surfaceRaised: Color { Color(red: 0.17, green: 0.19, blue: 0.18) }
  static var gridBase: Color { Color(red: 0.22, green: 0.25, blue: 0.24) }
  static var accent: Color { Color(red: 0.30, green: 0.82, blue: 0.76) }
  static var accentDeep: Color { Color(red: 0.12, green: 0.44, blue: 0.43) }
  static var warning: Color { Color(red: 0.95, green: 0.68, blue: 0.30) }
  static var danger: Color { Color(red: 0.92, green: 0.32, blue: 0.34) }
  static var success: Color { Color(red: 0.33, green: 0.78, blue: 0.48) }
  static var ink: Color { Color(red: 0.95, green: 0.96, blue: 0.92) }
  static var mutedInk: Color { Color(red: 0.68, green: 0.72, blue: 0.69) }
  static var separator: Color { Color.white.opacity(0.08) }

  static var backgroundGradient: LinearGradient {
    LinearGradient(
      colors: [backgroundTop, backgroundBottom],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  static var accentGradient: LinearGradient {
    LinearGradient(
      colors: [accent, Color(red: 0.83, green: 0.46, blue: 0.38)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  static var panelGradient: LinearGradient {
    LinearGradient(
      colors: [surfaceRaised.opacity(0.94), surface.opacity(0.94)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}
