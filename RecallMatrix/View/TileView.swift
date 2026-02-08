//
//  TileView.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 9/15/24.
//

import SwiftUI

struct TileView: View {
    var tile: Tile
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
 
    var body: some View {
        Rectangle()
            .foregroundStyle(tileColor)
            .aspectRatio(1, contentMode: .fit)
            .frame(minWidth: 44, minHeight: 44)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.2), radius: shadowRadius, x: 0, y: 4)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 1)
            }
            .overlay { stateIcon }
            .scaleEffect(reduceMotion ? 1 : (tile.isSelected ? 1.05 : 1), anchor: .center)
            .accessibilityIdentifier("TileButton_\(tile.id)")
            .accessibilityLabel(tileAccessibilityLabel)
            .accessibilityHint(tile.isSelected ? "Double tap to deselect this tile." : "Double tap to select this tile.")
            .accessibilityAddTraits(.isButton)
            .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: tile.isSelected)
    }
    var tileColor: LinearGradient {
        if tile.isCorrectTile {
            LinearGradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomLeading)
        } else if tile.isIncorrectTile {
            LinearGradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomLeading)
        } else if tile.isMissed {
            LinearGradient(colors: [Color.yellow.opacity(0.8), Color.yellow.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomLeading)
        } else if tile.isHighlighted {
            LinearGradient(colors: [Color.yellow.opacity(0.8), Color.yellow.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomLeading)
        }
        else if tile.isSelected {
            LinearGradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomLeading)
        } else {
            LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomLeading)
        }
    }
    
    private var tileAccessibilityLabel: String {
        if tile.isCorrectTile {
            return "Correct tile selected."
        } else if tile.isIncorrectTile {
            return "Incorrect tile selected."
        } else if tile.isMissed {
            return "A highlighted tile was missed."
        } else if tile.isSelected {
            return "Tile selected."
        } else {
            return "Tile not selected"
        }
    }
    @ViewBuilder
    private var stateIcon: some View {
        if let symbolName = stateSymbolName {
            Image(systemName: symbolName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                .accessibilityHidden(true)
        }
    }
    private var stateSymbolName: String? {
        if tile.isCorrectTile {
            return "checkmark.circle.fill"
        } else if tile.isIncorrectTile {
            return "xmark.circle.fill"
        } else if tile.isMissed {
            return "exclamationmark.triangle.fill"
        } else if differentiateWithoutColor && tile.isHighlighted {
            return "star.fill"
        } else if differentiateWithoutColor && tile.isSelected {
            return "circle.fill"
        } else {
            return nil
        }
    }
    var cornerRadius: CGFloat {
        valueFor(iOS: 12, macOS: 8, visionOS: 12)
    }
    var shadowRadius: CGFloat {
        valueFor(iOS: 6, macOS: 4, visionOS: 6)
    }
}

#Preview {
    TileView(tile: Tile(id: 1))
        .environment(GameModel())
}
