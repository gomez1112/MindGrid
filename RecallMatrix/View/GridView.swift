//
//  GridView.swift
//  RecallMatrix
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

            }
        }
    }
    var gameOverView: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.red)
                .padding()
            Text("Your Highest Score: \(highestScore)")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.primary)
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
        }
        .padding()
    }
    var gameUI: some View {
        VStack {
            HStack {
                Text("Score: \(model.score)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                Spacer()
                Text("Highest Score: \(highestScore)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
            }
            .padding()
            Text("Time Remaining: \(model.remainingTime) sec")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.top, 5)
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
    }
    var resultView: some View {
        VStack {
            Text(model.lastRoundCorrect ? "Great Job!" : "Try Again!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(model.lastRoundCorrect ? .green : .red)
                .padding()
                .transition(.scale)
                .animation(.easeInOut, value: model.lastRoundCorrect)
            
            Button {
                withAnimation {
                    model.startNewRound()
                }
            } label: {
                Text("Next Round")
                    .buttonBackground()
            }
            .buttonStyle(.plain)
        }
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

