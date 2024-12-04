//
//  Tile.swift
//  MemoryMatrix
//
//  Created by Gerard Gomez on 9/15/24.
//

import Foundation

struct Tile: Identifiable, Equatable {
    let id: Int
    var isHighlighted = false
    var isSelected = false
    var isCorrectTile = false
    var isIncorrectTile = false
    var isMissed = false
}
