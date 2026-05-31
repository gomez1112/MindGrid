//
//  CountdownOverlayView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 3/8/26.
//

import SwiftUI

struct CountdownOverlayView: View {
    let value: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 8) {
            Text("Memorize")
                .font(.caption)
                .foregroundStyle(MatrixTheme.mutedInk)
            Text("\(value)")
                .font(.system(.largeTitle, design: .rounded).bold().monospacedDigit())
                .foregroundStyle(MatrixTheme.accentGradient)
                .contentTransition(.numericText())
                .scaleEffect(reduceMotion ? 1.0 : 1.18)
        }
        .animation(
            reduceMotion ? .none : .spring(duration: 0.4, bounce: 0.5),
            value: value
        )
        .accessibilityLabel("Get ready: \(value)")
    }
}
