//
//  MatrixMetricTileView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct MatrixMetricTileView: View {
  var title: LocalizedStringKey
  var value: String
  var systemImage: String
  var tint: Color = MatrixTheme.accent

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image(systemName: systemImage)
          .foregroundStyle(tint)
          .accessibilityHidden(true)
        Spacer()
        Text(value)
          .font(.headline.monospacedDigit())
          .foregroundStyle(MatrixTheme.ink)
      }

      Text(title)
        .font(.caption)
        .foregroundStyle(MatrixTheme.mutedInk)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(MatrixTheme.surfaceRaised.opacity(0.82), in: .rect(cornerRadius: 18))
    .overlay {
      RoundedRectangle(cornerRadius: 18)
        .stroke(MatrixTheme.separator, lineWidth: 1)
    }
    .accessibilityElement(children: .combine)
  }
}
