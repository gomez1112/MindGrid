//
//  GameBoardView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct GameBoardView: View {
  var tiles: [Tile]
  var gridSize: Int
  var isSmallScreen: Bool
  var canSelect: Bool
  var selectTile: (Int) -> Void

  var body: some View {
    Grid(horizontalSpacing: isSmallScreen ? 9 : 14, verticalSpacing: isSmallScreen ? 9 : 14) {
      ForEach(0..<gridSize, id: \.self) { row in
        GridRow {
          ForEach(0..<gridSize, id: \.self) { column in
            let tileIdentifier = row * gridSize + column
            if let tileIndex = tiles.firstIndex(where: { $0.id == tileIdentifier }) {
              Button {
                selectTile(tileIndex)
              } label: {
                TileView(tile: tiles[tileIndex])
              }
              .buttonStyle(.plain)
              .disabled(!canSelect)
              .accessibilityLabel("Tile at row \(row + 1), column \(column + 1)")
            }
          }
        }
      }
    }
    .padding(isSmallScreen ? 12 : 18)
    .background(MatrixTheme.surface.opacity(0.78), in: .rect(cornerRadius: 28))
    .overlay {
      RoundedRectangle(cornerRadius: 28)
        .stroke(MatrixTheme.separator, lineWidth: 1)
    }
    .animation(.snappy, value: tiles)
  }
}
