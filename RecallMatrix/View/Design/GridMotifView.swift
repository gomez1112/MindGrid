//
//  GridMotifView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct GridMotifView: View {
  var body: some View {
    Grid(horizontalSpacing: 8, verticalSpacing: 8) {
      ForEach(0..<5, id: \.self) { row in
        GridRow {
          ForEach(0..<5, id: \.self) { column in
            let opacity = Double(row + column + 2) / 14.0
            Rectangle()
              .fill(.tint.opacity(opacity))
              .frame(width: 18, height: 18)
              .clipShape(.rect(cornerRadius: 4))
          }
        }
      }
    }
  }
}
