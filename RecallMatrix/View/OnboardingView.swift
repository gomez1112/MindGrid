//
//  OnboardingView.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct OnboardingView: View {
  @Environment(\.dismiss) private var dismiss
  @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
  @State private var mockHighlightedTiles: [Bool] = Array(repeating: false, count: 9)
  @State private var gridSize = 3
  @State private var isIncreasing = true
  @State private var currentStep = 1
  @State private var isGreenPhase = false
  @State private var animationTask: Task<Void, Never>?

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    NavigationStack {
      ZStack {
        MatrixBackgroundView()

        ScrollView {
          VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
              Text("How to play")
                .font(.largeTitle.bold())
                .foregroundStyle(MatrixTheme.ink)
              Text("Read the signal, wait for it to disappear, then rebuild it before the timer ends.")
                .font(.headline)
                .foregroundStyle(MatrixTheme.mutedInk)
            }
            .padding(.top)

            OnboardingStepView(
              currentStep: currentStep,
              mockHighlightedTiles: mockHighlightedTiles,
              gridSize: gridSize,
              isGreenPhase: isGreenPhase
            )
            .matrixPanel()

            HStack(spacing: 12) {
              if currentStep > 1 {
                Button("Back", systemImage: "chevron.left") {
                  withAnimation(.snappy) {
                    currentStep -= 1
                  }
                }
                .buttonStyle(.bordered)
                .tint(MatrixTheme.accent)
              }

              Spacer()

              if currentStep < 3 {
                Button("Next", systemImage: "chevron.right") {
                  withAnimation(.snappy) {
                    currentStep += 1
                  }
                }
                .buttonStyle(MatrixActionButtonStyle())
                .controlSize(useLargeControls ? .large : .regular)
              } else {
                Button("Get Started", systemImage: "play.fill") {
                  withAnimation(.snappy) {
                    hasSeenOnboarding = true
                    dismiss()
                  }
                }
                .buttonStyle(MatrixActionButtonStyle())
                .controlSize(useLargeControls ? .large : .regular)
              }
            }
          }
          .frame(maxWidth: 620, alignment: .leading)
          .padding()
        }
      }
      .toolbarBackground(.hidden, for: .navigationBar)
      .platform(for: .macOS) { $0.frame(minWidth: 600, minHeight: 500) }
      .platform(for: .macOS) { view in
        view.toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Dismiss", action: dismiss.callAsFunction)
          }
        }
      }
    }
    .frame(minWidth: 300)
    .task {
      guard !reduceMotion else { return }
      animationTask?.cancel()
      animationTask = Task {
        await runAnimations()
      }
    }
    .onDisappear {
      animationTask?.cancel()
      animationTask = nil
    }
  }

  private var useLargeControls: Bool {
    #if os(macOS) || os(visionOS)
    return true
    #else
    return horizontalSizeClass == .regular && verticalSizeClass == .regular
    #endif
  }

  @MainActor
  private func runAnimations() async {
    randomizeMockTiles()

    while !Task.isCancelled {
      try? await Task.sleep(for: .seconds(1.5))
      guard !Task.isCancelled else { return }

      withAnimation(.smooth) {
        isGreenPhase.toggle()
        if isIncreasing {
          gridSize = min(gridSize + 1, 6)
        } else {
          gridSize = max(gridSize - 1, 3)
        }
        isIncreasing.toggle()
      }

      if !isGreenPhase {
        randomizeMockTiles()
      }
    }
  }

  @MainActor
  private func randomizeMockTiles() {
    mockHighlightedTiles = Array(repeating: false, count: 9)
    let numberOfTilesToHighlight = Int.random(in: 2...4)
    for _ in 0..<numberOfTilesToHighlight {
      let randomIndex = Int.random(in: 0..<9)
      mockHighlightedTiles[randomIndex] = true
    }
  }
}
