//
//  TileView.swift
//  MemoryMatrix
//
//  Created by Gerard Gomez on 9/15/24.
//

import SwiftUI

struct TileView: View {
    var tile: Tile
    //let tileSize: CGFloat
 
    var body: some View {
        Rectangle()
            .foregroundStyle(tileColor)
           // .frame(width: tileSize, height: tileSize)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(.rect(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 1)
            }
            .scaleEffect(tile.isSelected ? 1.05 : 1, anchor: .center)
            .accessibilityIdentifier("TileButton_\(tile.id)")
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: tile.isSelected)
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
    
    var cornerRadius: CGFloat {
        #if os(macOS)
        return 8
        #else
        return 12
        #endif
    }
    var shadowRadius: CGFloat {
        #if os(macOS)
        return 4
        #else
        return 6
        #endif
    }
}

#Preview {
    TileView(tile: Tile(id: 1))
}
