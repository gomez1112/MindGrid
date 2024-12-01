//
//  GridView.swift
//  MemoryMatrix
//
//  Created by Gerard Gomez on 9/15/24.
//

import SwiftUI

struct GridView: View {
    @AppStorage("HighestScore") private var highestScore = 0
    @AppStorage("TimerDuration") private var timerDuration = 3
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
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 12))
                    
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
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
            .padding(.top)
            if model.gameState == .userInput {
                Text("Time Remaining: \(model.remainingTime) sec")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.top, 5)
            }
            GeometryReader { geometry in
                let availableWidth = geometry.size.width
                let availableHeight = geometry.size.height
                let padding: CGFloat = isSmallScreen ? 10 : 20
                let spacing: CGFloat = isSmallScreen ? 4 : 20
                let totalSpacing = spacing * CGFloat(model.gridSize - 1)
                let tileSize = min((availableWidth - padding * 2 - totalSpacing) / CGFloat(model.gridSize), (availableHeight - totalSpacing) / CGFloat(model.gridSize))
                let columns = Array(repeating: GridItem(.fixed(tileSize), spacing: spacing), count: model.gridSize)
                
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(model.tiles) { tile in
                        TileView(tile: tile, tileSize: tileSize)
                            .onTapGesture {
                                if model.gameState == .userInput,
                                   let index = model.tiles.firstIndex(where: { $0.id == tile.id }) {
                                    model.selectTile(at: index)
                                }
                            }
                    }
                }
                #if os(macOS) || os(visionOS)
                .padding(-10)
                #else
                .padding(padding)
                #endif
                .animation(.easeInOut, value: model.tiles)
            }
            
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
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                .clipShape(.rect(cornerRadius: 12))
                .shadow(radius: 6)
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
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                .clipShape(.rect(cornerRadius: 12))
                .shadow(radius: 6)
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
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    .clipShape(.rect(cornerRadius: 12))
                    .shadow(radius: 6)
            }
            .buttonStyle(.plain)
        }
    }
    var isSmallScreen: Bool {
        #if os(macOS)
        return false
        #else
        return horizontalSizeClass == .compact && verticalSizeClass == .compact
        #endif
    }
}

#Preview {
    GridView()
        .environment(DataModel())
}

