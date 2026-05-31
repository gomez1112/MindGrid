//
//  MatrixPanelModifier.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct MatrixPanelModifier: ViewModifier {
  var cornerRadius: CGFloat = 24

  func body(content: Content) -> some View {
    content
      .padding()
      .background(MatrixTheme.panelGradient, in: .rect(cornerRadius: cornerRadius))
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(MatrixTheme.separator, lineWidth: 1)
      }
      .shadow(color: .black.opacity(0.24), radius: 18, y: 12)
  }
}

extension View {
  func matrixPanel(cornerRadius: CGFloat = 24) -> some View {
    modifier(MatrixPanelModifier(cornerRadius: cornerRadius))
  }
}
