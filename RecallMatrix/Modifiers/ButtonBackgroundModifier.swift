//
//  ButtonBackgroundModifier.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/2/24.
//

import Foundation

import SwiftUI

struct ButtonBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)
    }
}
extension View {
    func buttonBackground() -> some View {
        self.modifier(ButtonBackgroundModifier())
    }
}
