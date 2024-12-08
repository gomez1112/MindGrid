//
//  GridView.swift
//
//
//  Created by Gerard Gomez on 9/15/24.
//

import SwiftData
import SwiftUI

struct GridView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("HighestScore") private var highestScore = 0
    @AppStorage("TimerDuration") private var timerDuration = 30
    @Environment(DataModel.self) private var model
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query private var gameSessions: [GameSession]
    
    var body: some View {
        NavigationStack {
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
            HStack {
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
                NavigationLink(destination: StartScreenView()) {
                    Text("Start Screen")
                        .buttonBackground()
                }
                .buttonStyle(.plain)
                .padding(.top, 20)
            }
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
        .frame(maxWidth: 600)
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
        .buttonStyle(.plain)
        .controlSize(useLargeControls ? .large : .regular)
        .accessibilityIdentifier("Start Game")
        .accessibilityLabel("Start Game")
        .accessibilityHint("Begins the first round.")
  
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
            let correctTiles = model.tiles.filter { $0.isCorrectTile }.count
            let totalHighlighted = model.highlightedTileIndices.count
            let elapsedTime = Double(timerDuration - model.remainingTime)
            
            recordGameSession(score: model.score, gridSize: model.gridSize, correctTiles: correctTiles, totalTiles: totalHighlighted, elapsedTime: elapsedTime)
            
        } label: {
            Text("Check Result")
                .buttonBackground()
        }
        .buttonStyle(.plain)
        .controlSize(useLargeControls ? .large : .regular)
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
            .controlSize(useLargeControls ? .large : .regular)
            .accessibilityLabel("Next Round")
            .accessibilityHint("Proceed to the next round of the game.")
        }
        .accessibilityElement(children: .contain)
    }
    var useLargeControls: Bool {
        #if os(macOS) || os(visionOS)
        return true
        #else
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
        #endif
    }
    var isSmallScreen: Bool {
        #if os(macOS)
        return false
        #else
        return horizontalSizeClass == .compact || verticalSizeClass == .compact
        #endif
    }
    func recordGameSession(score: Int, gridSize: Int, correctTiles: Int, totalTiles: Int, elapsedTime: TimeInterval) {
        let session = GameSession(date: Date(), score: score, gridSize: gridSize, correctTiles: correctTiles, totalTiles: totalTiles, elapsedTime: elapsedTime)
        context.insert(session)
    }
}

#Preview {
    NavigationStack {
        GridView()
            .environment(DataModel())
    }
}

