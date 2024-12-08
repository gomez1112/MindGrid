//
//  GradientBackgroundView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/7/24.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .blue.opacity(0.1),
                .red.opacity(0.1),
                .blue.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}


#Preview {
    GradientBackgroundView()
}
