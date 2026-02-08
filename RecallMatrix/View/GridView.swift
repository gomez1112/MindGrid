//
//  GridView.swift
//
//
//  Created by Gerard Gomez on 9/15/24.
//

import StoreKit
import SwiftData
import SwiftUI

struct GridView: View {
    @Environment(\.requestReview) private var requestReview
    @Environment(\.modelContext) private var context
    @AppStorage("HighestScore") private var highestScore = 0
    @AppStorage("TimerDuration") private var timerDuration = 30
    @Environment(GameModel.self) private var game
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Query private var gameSessions: [GameSession]
    var body: some View {
            VStack {
                if game.gameState == .gameOver {
                    gameOverView
                } else {
                    gameUI
                }
            }
            .padding()
            .onAppear { game.updateTimerDuration(timerDuration) }
            .onChange(of: timerDuration) { _, newValue in
                if game.gameState == .userInput {
                    game.timerDuration = newValue
                } else {
                    game.updateTimerDuration(newValue)
                }
            }
            .onDisappear {
                if game.gameState == .userInput {
                    game.pauseGame()
                }
            }
            .navigationBarBackButtonHidden(game.gameState != .gameOver)
            .accessibilityElement(children: .contain)
        
    }
    var gameOverView: some View {
        VStack {
            Text("Game Over")
                .font(.title.bold())
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
                        game.resetGame()
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
                Text("Score: \(game.score)")
                    .font(.title2.bold())
                    .platformNot(for: .visionOS) {
                        $0.foregroundStyle(Constant.Style.blueToPurple)
                    }
                    .accessibilityLabel("Score: \(game.score)")
                Spacer()
                Text("Highest Score: \(highestScore)")
                    .font(.title2.bold())
                    .platformNot(for: .visionOS) {
                        $0.foregroundStyle(Constant.Style.blueToPurple)
                    }
                    .accessibilityLabel("Highest Score: \(highestScore)")
            }
            .padding()
            Text("Time Remaining: \(game.remainingTime) sec")
                .font(.title3.weight(.medium))
                .platformNot(for: .visionOS) {
                    $0.foregroundStyle(Constant.Style.blueToPurple)
                }
                .padding(.top, 5)
                .accessibilityLabel("Time remaining: \(game.remainingTime) seconds")
            Grid(horizontalSpacing: isSmallScreen ? 12 : 30, verticalSpacing: isSmallScreen ? 12 : 30) {
                ForEach(0..<game.gridSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<game.gridSize, id: \.self) { column in
                            if let tileIndex = game.tiles.firstIndex(where: { $0.id == row * game.gridSize + column}) {
                                TileView(tile: game.tiles[tileIndex])
                                    .onTapGesture {
                                        if game.gameState == .userInput {
                                            game.selectTile(at: tileIndex)
                                        }
                                    }
                                    .accessibilityLabel("Tile at position row \(row + 1), column \(column + 1)")
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut, value: game.tiles)
            Spacer()
            // Show Pause/Resume button only when in user input state.
            if game.gameState == .userInput {
                pauseResumeButton
                    .padding()
            }
            switch game.gameState {
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
    @ViewBuilder
    var pauseResumeButton: some View {
        // This button is only visible during the user input phase.
        if game.gameState == .userInput {
            Button {
                if game.paused {
                    game.resumeGame()
                } else {
                    game.pauseGame()
                }
            } label: {
                Text(game.paused ? "Resume" : "Pause")
                    .buttonBackground()
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("PauseResumeButton")
            .accessibilityLabel(game.paused ? "Resume Game" : "Pause Game")
        } else {
            EmptyView()
        }
    }

    var startButton: some View {
        Button {
            withAnimation {
                game.startNewRound()
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
                game.checkResult()
            }
            if game.gridSize == 10 {
                requestReview()
            }
            if game.score > highestScore {
                highestScore = game.score
            }
            // Record EVERY session, not just game over
            let correctTiles = game.tiles.filter { $0.isCorrectTile }.count
            let totalHighlighted = game.highlightedTileIndices.count
            let elapsedTime = Double(game.timerDuration - game.remainingTime)
            recordGameSession(
                score: game.score,
                gridSize: game.gridSize,
                correctTiles: correctTiles,
                totalTiles: totalHighlighted,
                elapsedTime: elapsedTime
            )
            
            // If game is over, call gameOver
            if game.score <= 0 {
                game.gameOver()
            }
            
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
            Text(game.lastRoundCorrect ? "Great Job!" : "Try Again!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(game.lastRoundCorrect ? .green : .red)
                .padding()
                .transition(.scale)
                .animation(.easeInOut, value: game.lastRoundCorrect)
                .accessibilityLabel(game.lastRoundCorrect ? "Great Job! You got it correct." : "Try Again!. Your selection was incorrect.")
            
            Button {
                withAnimation {
                    game.startNewRound()
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
            .environment(GameModel())
    }
}
