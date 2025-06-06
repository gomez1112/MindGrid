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
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var useLargeControls: Bool {
        #if os(macOS) || os(visionOS)
        return true
        #else
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
        #endif
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                
                VStack(spacing: 30) {
                    Text("How to Play")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .padding(.top)
                    // Step Explanation and Animation
                    Group {
                        if currentStep == 1 {
                            explanationStep1
                        } else if currentStep == 2 {
                            explanationStep2
                        } else {
                            explanationStep3
                        }
                    }
                    
                    Spacer()
                    // Navigation Controls
                    HStack {
                        if currentStep > 1 {
                            Button {
                                withAnimation {
                                    currentStep -= 1
                                }
                            } label: {
                                Text("Back")
                                    .buttonBackground()
                            }
                            .buttonStyle(.plain)
                            .controlSize(useLargeControls ? .large : .regular)
                            .accessibilityLabel("Go back to previous tutorial step.")
                        }
                        Spacer()
                        if currentStep < 3 {
                            Button {
                                withAnimation {
                                    currentStep += 1
                                }
                            } label: {
                                Text("Next")
                                    .buttonBackground()
                            }
                            .buttonStyle(.plain)
                            .controlSize(useLargeControls ? .large : .regular)
                            .accessibilityLabel("Proceed to the next tutorial step.")
                        } else {
                            Button {
                                withAnimation {
                                    hasSeenOnboarding = true
                                    dismiss()
                                }
                            } label: {
                                Text("Get Started")
                                    .buttonBackground()
                            }
                            .buttonStyle(.plain)
                            .controlSize(useLargeControls ? .large : .regular)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 600)
                
            }
            .platform(for: .macOS) { $0.frame(minWidth: 600, minHeight: 500) }
            .platform(for: .macOS) { $0.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            }
        }
        .frame(minWidth: 300)
    }
    
    var explanationStep1: some View {
        VStack(spacing: 20) {
            Text("**Memorize the Pattern**")
                .font(.title)
                .foregroundStyle(.primary)
            Text("Watch the highlighted tiles carefully.")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("**Recall and Select**")
            Text("After the pattern disappears, select the tiles that were highlighted.")
            mockGridView
                .onAppear {
                    startMockHighlighting()
                }
        }
    }
    
    var explanationStep2: some View {
        VStack(spacing: 20) {
            Text("**Recall and Select**")
                .font(.title)
                .foregroundStyle(.primary)
            Text("Tap the tiles you remember as highlighted.")
                .font(.headline)
                .foregroundStyle(.secondary)
            Image(systemName: "hand.tap")
                .symbolEffect(.bounce)
                .font(.system(size: 100))
                .foregroundStyle(Constant.Style.blueToPurple)
            dynamicDifficultySection
        }
        .onAppear {
            animateGridSize()
        }
    }
    
    var explanationStep3: some View {
        VStack(spacing: 20) {
            Text("**Beat the Timer**")
                .font(.title)
                .foregroundStyle(.primary)
            Text("Submit your answers before time runs out!")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
            Image(systemName: "clock.fill")
                .symbolEffect(.rotate, options: .nonRepeating)
                .font(.system(size: 100))
                .foregroundStyle(Constant.Style.blueToPurple)
                .accessibilityLabel("Countdown icon")
            Spacer()
        }
    }
    var dynamicDifficultySection: some View {
        VStack(spacing: 20) {
            Text("Dynamic Difficulty")
                .font(.title.bold())
            Text("As you progress, the grid size increases, making the game more challenging. If you miss patterns, the grid size decreases to help you improve.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
            VStack {
                Text("Current Grid Size: \(gridSize) x \(gridSize)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Grid(horizontalSpacing: 4,verticalSpacing: 4) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        GridRow {
                            ForEach(0..<gridSize, id: \.self) { column in
                                Rectangle()
                                    .foregroundStyle(.blue.opacity(0.5))
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                }
                .animation(.easeInOut(duration: 1.5), value: gridSize)
            }
        }
    }
    private func animateGridSize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if isIncreasing {
                gridSize = min(gridSize + 1, 6)
            } else {
                gridSize = max(gridSize - 1, 3)
            }
            isIncreasing.toggle()
            animateGridSize()
        }
    }
    var mockGridView: some View {
        VStack(spacing: 20) {
            Text(isGreenPhase ? "You selected the correct tiles." : "Remember the yellow tiles")
                .font(.title)
                .foregroundStyle(isGreenPhase ? .green : .yellow)
                .animation(.easeInOut, value: isGreenPhase)
            
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                ForEach(0..<3, id: \.self) { row in
                    GridRow {
                        ForEach(0..<3, id: \.self) { column in
                            Rectangle()
                                .foregroundStyle(
                                    mockHighlightedTiles[row * 3 + column]
                                    ? (isGreenPhase ? .green : .yellow)
                                    : .gray.opacity(0.4)
                                )
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
    }
    
    private func startMockHighlighting() {
        // Randomly highlight tiles for the yellow phase
        mockHighlightedTiles = Array(repeating: false, count: 9)
        let numberOfTilesToHighlight = Int.random(in: 2...4)
        for _ in 0..<numberOfTilesToHighlight {
            let randomIndex = Int.random(in: 0..<9)
            mockHighlightedTiles[randomIndex] = true
        }
        
        // Alternate phases using DispatchQueue
        updatePhase()
    }
    
    private func updatePhase() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isGreenPhase.toggle() // Switch between yellow and green
            if !isGreenPhase {
                // If switching back to yellow, randomize the tiles
                startMockHighlighting()
            } else {
                // Continue toggling phases
                updatePhase()
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environment(GameModel())
}
