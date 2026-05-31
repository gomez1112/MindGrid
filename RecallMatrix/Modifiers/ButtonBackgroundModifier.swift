//
//  ButtonBackgroundModifier.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/2/24.
//

import SwiftUI

/// A view modifier that applies a consistent background style to buttons.
struct ButtonBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(MatrixTheme.backgroundTop)
            .padding(.vertical)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(MatrixTheme.accentGradient, in: .rect(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.16), lineWidth: 1)
            }
            .contentShape(.rect)
    }
}
extension View {
    func buttonBackground() -> some View {
        self.modifier(ButtonBackgroundModifier())
    }
}
