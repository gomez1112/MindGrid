//
//  MatrixBackgroundView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct MatrixBackgroundView: View {
  var body: some View {
    MatrixTheme.backgroundGradient
      .overlay(alignment: .topTrailing) {
        GridMotifView()
          .foregroundStyle(MatrixTheme.accent.opacity(0.12))
          .padding(.top)
          .padding(.trailing)
      }
      .ignoresSafeArea()
  }
}
