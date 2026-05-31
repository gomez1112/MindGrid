//
//  MatrixActionButtonStyle.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct MatrixActionButtonStyle: ButtonStyle {
  var role: ButtonRole?

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(role == .destructive ? MatrixTheme.danger : MatrixTheme.backgroundTop)
      .padding(.vertical)
      .padding(.horizontal)
      .frame(maxWidth: .infinity)
      .background(buttonBackground, in: .rect(cornerRadius: 16))
      .overlay {
        RoundedRectangle(cornerRadius: 16)
          .stroke(role == .destructive ? MatrixTheme.danger.opacity(0.35) : .white.opacity(0.18), lineWidth: 1)
      }
      .scaleEffect(configuration.isPressed ? 0.98 : 1)
      .animation(.snappy, value: configuration.isPressed)
  }

  private var buttonBackground: AnyShapeStyle {
    if role == .destructive {
      return AnyShapeStyle(MatrixTheme.danger.opacity(0.14))
    }

    return AnyShapeStyle(MatrixTheme.accentGradient)
  }
}
