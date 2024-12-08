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
    @State private var currentStep = 1
    @State private var isGreenPhase = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.2), .red.opacity(0.1), .blue.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("How to Play")
                        .font(.largeTitle)
                        .fontWeight(.bold)
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
                        }
                    }
                }
                .padding()
            }
        }
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
            Spacer()
            Image(systemName: "hand.tap")
                .symbolEffect(.bounce)
                .font(.system(size: 100))
                .foregroundStyle(.purple)
            Spacer()
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
                .foregroundStyle(.blue)
            Spacer()
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
}
