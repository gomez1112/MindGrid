//
//  GridView.swift
//
//
//  Created by Gerard Gomez on 9/15/24.
//

import SwiftUI

struct GridView: View {
    @AppStorage("HighestScore") private var highestScore = 0
    @AppStorage("TimerDuration") private var timerDuration = 30
    @Environment(DataModel.self) private var model
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        VStack {
            if model.gameState == .gameOver {
                gameOverView
            } else {
                gameUI
            }
        }
        .onAppear {
            model.updateTimerDuration(timerDuration)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
                .accessibilityLabel("Settings")
                .accessibilityHint("Open game settings")
            }
        }
        .accessibilityElement(children: .contain)
    }
    var gameOverView: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.red)
                .padding()
                .accessibilityLabel("Game Over")
                .accessibilityHint("Your final score is displayed.")
            Text("Your Highest Score: \(highestScore)")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.primary)
                .accessibilityLabel("Your highest score is \(highestScore).")
            Spacer()
            Button {
                withAnimation {
                    model.resetGame()
                }
            } label: {
                Text("Restart")
                    .buttonBackground()
                    
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
            .keyboardShortcut("r", modifiers: [.command])
            .accessibilityLabel("Restart game")
            .accessibilityHint("Starts a new game from the beginning.")
        }
        .padding()
        .accessibilityElement(children: .contain)
    }
    var gameUI: some View {
        VStack {
            HStack {
                Text("Score: \(model.score)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .accessibilityLabel("Score: \(model.score)")
                Spacer()
                Text("Highest Score: \(highestScore)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .accessibilityLabel("Highest Score: \(highestScore)")
            }
            .padding()
            Text("Time Remaining: \(model.remainingTime) sec")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.top, 5)
                .accessibilityLabel("Time remaining: \(model.remainingTime) seconds")
            Grid(horizontalSpacing: isSmallScreen ? 12 : 30, verticalSpacing: isSmallScreen ? 12 : 30) {
                ForEach(0..<model.gridSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<model.gridSize, id: \.self) { column in
                            if let tileIndex = model.tiles.firstIndex(where: { $0.id == row * model.gridSize + column}) {
                                TileView(tile: model.tiles[tileIndex])
                                    .onTapGesture {
                                        if model.gameState == .userInput {
                                            model.selectTile(at: tileIndex)
                                        }
                                    }
                                    .accessibilityLabel("Tile at position row \(row + 1), column \(column + 1)")
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut, value: model.tiles)
            Spacer()
            
            switch model.gameState {
                case .start:
                    startButton
                        .padding()
                case .userInput:
                    checkResultButton
                        .padding()
                case .result:
                    resultView
                        .padding()
                default:
                    EmptyView()
            }
        
        }
        .padding(.horizontal, isSmallScreen ? 20 : 40)
    }
    var startButton: some View {
        Button {
            withAnimation {
                model.startNewRound()
            }
            
        } label: {
            Text("Start Game")
                .buttonBackground()
        }
        .accessibilityIdentifier("Start Game")
        .accessibilityLabel("Start Game")
        .accessibilityHint("Begins the first round.")
        .buttonStyle(.plain)
    }
    var checkResultButton: some View {
        Button {
            withAnimation {
                model.checkResult()
            }
            if model.score > highestScore {
                highestScore = model.score
            }
            if model.score <= 0 {
                model.gameOver()
            }
            
        } label: {
            Text("Check Result")
                .buttonBackground()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Check Result")
        .accessibilityHint("Check if your selected tiles match the pattern.")
    }
    var resultView: some View {
        VStack {
            Text(model.lastRoundCorrect ? "Great Job!" : "Try Again!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(model.lastRoundCorrect ? .green : .red)
                .padding()
                .transition(.scale)
                .animation(.easeInOut, value: model.lastRoundCorrect)
                .accessibilityLabel(model.lastRoundCorrect ? "Great Job! You got it correct." : "Try Again!. Your selection was incorrect.")
            
            Button {
                withAnimation {
                    model.startNewRound()
                }
            } label: {
                Text("Next Round")
                    .buttonBackground()
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Next Round")
            .accessibilityHint("Proceed to the next round of the game.")
        }
        .accessibilityElement(children: .contain)
    }
    var isSmallScreen: Bool {
        #if os(macOS)
        return false
        #else
        return horizontalSizeClass == .compact || verticalSizeClass == .compact
        #endif
    }
}

#Preview {
    GridView()
        .environment(DataModel())
}

