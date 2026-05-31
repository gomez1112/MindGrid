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
      .fill(tileFill)
      .aspectRatio(1, contentMode: .fit)
      .frame(minWidth: 44, minHeight: 44)
      .clipShape(.rect(cornerRadius: cornerRadius))
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(tileBorderColor, lineWidth: tileBorderWidth)
      }
      .overlay {
        stateIcon
      }
      .shadow(color: tileGlowColor, radius: tileGlowRadius)
      .shadow(color: .black.opacity(0.20), radius: shadowRadius, y: 6)
      .scaleEffect(reduceMotion ? 1 : tileScale, anchor: .center)
      .phaseAnimator(
        tile.isIncorrectTile ? [0.0, -6.0, 6.0, -4.0, 4.0, 0.0] : [0.0],
        trigger: tile.isIncorrectTile
      ) { content, offset in
        content.offset(x: offset)
      } animation: { _ in
        reduceMotion ? .none : .snappy(duration: 0.08)
      }
      .accessibilityIdentifier("TileButton_\(tile.id)")
      .accessibilityLabel(tileAccessibilityLabel)
      .accessibilityHint(tile.isSelected ? "Double tap to deselect this tile." : "Double tap to select this tile.")
      .animation(reduceMotion ? .none : .snappy, value: tile.isSelected)
      .animation(reduceMotion ? .none : .smooth, value: tile.isCorrectTile)
      .animation(reduceMotion ? .none : .smooth, value: tile.isHighlighted)
  }

  private var tileScale: CGFloat {
    if tile.isHighlighted { return 1.04 }
    if tile.isSelected { return 1.05 }
    if tile.isCorrectTile { return 1.03 }
    return 1
  }

  private var tileBorderColor: Color {
    if tile.isCorrectTile { return MatrixTheme.success }
    if tile.isIncorrectTile { return MatrixTheme.danger }
    if tile.isMissed { return MatrixTheme.warning }
    if tile.isHighlighted { return MatrixTheme.warning }
    if tile.isSelected { return MatrixTheme.accent }
    return MatrixTheme.separator
  }

  private var tileBorderWidth: CGFloat {
    if tile.isCorrectTile || tile.isIncorrectTile || tile.isHighlighted || tile.isSelected { return 2 }
    return 1
  }

  private var tileGlowColor: Color {
    if tile.isCorrectTile { return MatrixTheme.success.opacity(0.48) }
    if tile.isIncorrectTile { return MatrixTheme.danger.opacity(0.42) }
    if tile.isHighlighted { return MatrixTheme.warning.opacity(0.42) }
    if tile.isSelected { return MatrixTheme.accent.opacity(0.42) }
    return .clear
  }

  private var tileGlowRadius: CGFloat {
    if tile.isCorrectTile || tile.isIncorrectTile || tile.isHighlighted || tile.isSelected {
      return 10
    }

    return 0
  }

  private var tileFill: LinearGradient {
    if tile.isCorrectTile {
      return LinearGradient(colors: [MatrixTheme.success, MatrixTheme.success.opacity(0.62)], startPoint: .topLeading, endPoint: .bottomTrailing)
    } else if tile.isIncorrectTile {
      return LinearGradient(colors: [MatrixTheme.danger, MatrixTheme.danger.opacity(0.62)], startPoint: .topLeading, endPoint: .bottomTrailing)
    } else if tile.isMissed || tile.isHighlighted {
      return LinearGradient(colors: [MatrixTheme.warning, MatrixTheme.warning.opacity(0.58)], startPoint: .topLeading, endPoint: .bottomTrailing)
    } else if tile.isSelected {
      return LinearGradient(colors: [MatrixTheme.accent, MatrixTheme.accentDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    return LinearGradient(colors: [MatrixTheme.gridBase.opacity(0.95), MatrixTheme.gridBase.opacity(0.62)], startPoint: .topLeading, endPoint: .bottomTrailing)
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
      return "Tile not selected."
    }
  }

  @ViewBuilder
  private var stateIcon: some View {
    if let symbolName = stateSymbolName {
      Image(systemName: symbolName)
        .font(.title3.bold())
        .foregroundStyle(MatrixTheme.ink)
        .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
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

  private var cornerRadius: CGFloat {
    valueFor(iOS: 14, macOS: 10, visionOS: 14)
  }

  private var shadowRadius: CGFloat {
    valueFor(iOS: 8, macOS: 5, visionOS: 8)
  }
}
