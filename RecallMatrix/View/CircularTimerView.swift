//
//  CircularTimerView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 3/8/26.
//

import SwiftUI

struct CircularTimerView: View {
    let remainingTime: Int
    let totalTime: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(remainingTime) / Double(totalTime)
    }

    private var timerColor: Color {
        switch progress {
        case 0.5...1.0: return .green
        case 0.25..<0.5: return .yellow
        default: return .red
        }
    }

    private var isCritical: Bool {
        remainingTime <= 5 && remainingTime > 0
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(timerColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.3), value: progress)

            Text("\(remainingTime)")
                .font(.title2.bold().monospacedDigit())
                .foregroundStyle(timerColor)
                .contentTransition(.numericText())
        }
        .frame(width: 60, height: 60)
        .scaleEffect(isCritical && !reduceMotion ? 1.08 : 1.0)
        .animation(
            isCritical && !reduceMotion
                ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
                : .default,
            value: isCritical
        )
        .accessibilityLabel("Time remaining: \(remainingTime) seconds")
    }
}

#Preview {
    VStack(spacing: 20) {
        CircularTimerView(remainingTime: 25, totalTime: 30)
        CircularTimerView(remainingTime: 10, totalTime: 30)
        CircularTimerView(remainingTime: 3, totalTime: 30)
    }
}
