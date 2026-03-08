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
            .navigationBarBackButtonHidden(game.gameState != .gameOver && game.gameState != .start)
            .toolbar {
                if game.gameState != .start && game.gameState != .gameOver {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            if game.score > highestScore {
                                highestScore = game.score
                            }
                            withAnimation {
                                game.gameOver()
                            }
                        } label: {
                            Text("End Game")
                                .foregroundStyle(.red)
                        }
                        .accessibilityLabel("End Game")
                        .accessibilityHint("Ends the current game and shows your results.")
                    }
                }
            }
            .accessibilityElement(children: .contain)
        
    }
    var gameOverView: some View {
        VStack(spacing: 16) {
            Text("Game Over")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.red)
                .accessibilityLabel("Game Over")
            
            // Final stats card
            VStack(spacing: 12) {
                statRow(label: "Final Score", value: "\(game.score)")
                statRow(label: "Highest Score", value: "\(highestScore)")
                statRow(label: "Rounds Played", value: "\(game.roundCount)")
                statRow(label: "Best Streak", value: "\(game.bestStreak)")
                statRow(label: "Correct Rounds", value: "\(game.totalCorrectRounds)")
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            
            Text(encouragingMessage)
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel(encouragingMessage)
            
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
                .keyboardShortcut("r", modifiers: [.command])
                .accessibilityLabel("Restart game")
                .accessibilityHint("Starts a new game from the beginning.")
                NavigationLink(destination: StartScreenView()) {
                    Text("Start Screen")
                        .buttonBackground()
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .accessibilityElement(children: .contain)
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline.bold())
        }
        .accessibilityElement(children: .combine)
    }
    
    private var encouragingMessage: String {
        if game.bestStreak >= 5 {
            return "Amazing streak! You're a memory master!"
        } else if game.totalCorrectRounds >= 5 {
            return "Great job! Your memory is impressive!"
        } else if game.score > 0 {
            return "Good effort! Keep practicing to improve!"
        } else {
            return "Don't give up! Every game makes you better!"
        }
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
            .padding(.horizontal)
            // Round info, grid size, and streak
            HStack {
                Text("Round \(game.roundCount)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Round \(game.roundCount)")
                Spacer()
                Text("\(game.gridSize)x\(game.gridSize)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Grid size \(game.gridSize) by \(game.gridSize)")
                Spacer()
                if game.currentStreak >= 2 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                            .symbolEffect(.bounce, value: game.currentStreak)
                        Text("\(game.currentStreak)")
                            .font(.headline.bold())
                            .foregroundStyle(.orange)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityLabel("Streak of \(game.currentStreak) correct rounds")
                }
            }
            .padding(.horizontal)
            .animation(.spring(response: 0.3), value: game.currentStreak)
            // Circular timer
            if game.gameState == .userInput {
                CircularTimerView(remainingTime: game.remainingTime, totalTime: game.timerDuration)
                    .padding(.top, 5)
            }
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
                case .countdown:
                    CountdownOverlayView(value: game.countdownValue)
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
        VStack(spacing: 12) {
            Text(game.lastRoundCorrect ? "Great Job!" : "Try Again!")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(game.lastRoundCorrect ? .green : .orange)
                .scaleEffect(game.lastRoundCorrect ? 1.1 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: game.lastRoundCorrect)
                .accessibilityLabel(game.lastRoundCorrect ? "Great Job! You got it correct." : "Try Again! Your selection was incorrect.")
            
            // Accuracy display
            let correctCount = game.tiles.filter { $0.isCorrectTile }.count
            let totalHighlighted = game.highlightedTileIndices.count
            Text("\(correctCount)/\(totalHighlighted) tiles correct")
                .font(.title3)
                .foregroundStyle(.secondary)
                .accessibilityLabel("\(correctCount) out of \(totalHighlighted) tiles correct")
            
            // Streak display on correct
            if game.lastRoundCorrect && game.currentStreak >= 2 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("Streak: \(game.currentStreak)")
                        .font(.headline.bold())
                        .foregroundStyle(.orange)
                }
                .transition(.scale.combined(with: .opacity))
                .accessibilityLabel("You're on a streak of \(game.currentStreak)")
            }
            
            // Bonus points indicator
            if game.lastRoundCorrect {
                let bonus = game.currentStreak >= 5 ? 3 : (game.currentStreak >= 3 ? 2 : 1)
                if bonus > 1 {
                    Text("+\(bonus) points!")
                        .font(.headline)
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityLabel("Plus \(bonus) points bonus")
                }
            }
            
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
