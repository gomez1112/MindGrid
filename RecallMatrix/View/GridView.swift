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
    ScrollView {
      VStack(spacing: 18) {
        if game.gameState == .gameOver {
          GameOverSummaryView(
            score: game.score,
            highestScore: highestScore,
            roundCount: game.roundCount,
            bestStreak: game.bestStreak,
            totalCorrectRounds: game.totalCorrectRounds,
            message: encouragingMessage,
            restart: restartGame
          )
        } else {
          GameScoreHeaderView(
            score: game.score,
            highestScore: highestScore,
            roundCount: game.roundCount,
            gridSize: game.gridSize,
            currentStreak: game.currentStreak
          )

          if game.gameState == .userInput {
            CircularTimerView(remainingTime: game.remainingTime, totalTime: game.timerDuration)
          }

          GameBoardView(
            tiles: game.tiles,
            gridSize: game.gridSize,
            isSmallScreen: isSmallScreen,
            canSelect: game.gameState == .userInput,
            selectTile: selectTile
          )

          GamePhaseControlView(
            gameState: game.gameState,
            countdownValue: game.countdownValue,
            paused: game.paused,
            lastRoundCorrect: game.lastRoundCorrect,
            currentStreak: game.currentStreak,
            correctTileCount: game.tiles.filter { $0.isCorrectTile }.count,
            totalHighlighted: game.highlightedTileIndices.count,
            useLargeControls: useLargeControls,
            start: startRound,
            checkResult: checkResult,
            togglePause: togglePause
          )
        }
      }
      .frame(maxWidth: 680)
      .padding()
    }
    .defaultScrollAnchor(.center, for: .alignment)
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
    .navigationTitle("Recall Matrix")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(game.gameState != .gameOver && game.gameState != .start)
    .toolbar {
      if game.gameState != .start && game.gameState != .gameOver {
        ToolbarItem(placement: .cancellationAction) {
          Button("End Game", systemImage: "xmark") {
            endGame()
          }
          .foregroundStyle(MatrixTheme.danger)
          .accessibilityHint("Ends the current game and shows your results.")
        }
      }
    }
    .accessibilityElement(children: .contain)
  }

  private var encouragingMessage: String {
    if game.bestStreak >= 5 {
      return "Sharp streak. Your pattern recall is locked in."
    } else if game.totalCorrectRounds >= 5 {
      return "Strong run. You kept control as the board expanded."
    } else if game.score > 0 {
      return "Good session. A few cleaner reads will push the streak higher."
    } else {
      return "Reset, watch the signal, and build from the first pattern."
    }
  }

  private var useLargeControls: Bool {
    #if os(macOS) || os(visionOS)
    return true
    #else
    return horizontalSizeClass == .regular && verticalSizeClass == .regular
    #endif
  }

  private var isSmallScreen: Bool {
    #if os(macOS)
    return false
    #else
    return horizontalSizeClass == .compact || verticalSizeClass == .compact
    #endif
  }

  private func selectTile(_ index: Int) {
    game.selectTile(at: index)
  }

  private func startRound() {
    withAnimation(.snappy) {
      game.startNewRound()
    }
  }

  private func restartGame() {
    withAnimation(.snappy) {
      game.resetGame()
    }
  }

  private func togglePause() {
    if game.paused {
      game.resumeGame()
    } else {
      game.pauseGame()
    }
  }

  private func endGame() {
    if game.score > highestScore {
      highestScore = game.score
    }

    withAnimation(.snappy) {
      game.gameOver()
    }
  }

  private func checkResult() {
    withAnimation(.snappy) {
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
  }

  private func recordGameSession(score: Int, gridSize: Int, correctTiles: Int, totalTiles: Int, elapsedTime: TimeInterval) {
    let session = GameSession(
      date: Date(),
      score: score,
      gridSize: gridSize,
      correctTiles: correctTiles,
      totalTiles: totalTiles,
      elapsedTime: elapsedTime
    )
    context.insert(session)
  }
}
