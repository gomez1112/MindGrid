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
        Text("\(value)")
            .font(.system(size: 72, weight: .bold, design: .rounded))
            .foregroundStyle(Constant.Style.blueToPurple)
            .contentTransition(.numericText())
            .scaleEffect(reduceMotion ? 1.0 : 1.2)
            .animation(
                reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.5),
                value: value
            )
            .accessibilityLabel("Get ready: \(value)")
    }
}

#Preview {
    CountdownOverlayView(value: 3)
}
