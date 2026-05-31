//
//  MatrixStatusPillView.swift
//  RecallMatrix
//
//  Created by Codex on 5/30/26.
//

import SwiftUI

struct MatrixStatusPillView: View {
  var title: LocalizedStringKey
  var value: String
  var systemImage: String
  var tint: Color = MatrixTheme.accent

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: systemImage)
        .foregroundStyle(tint)
        .accessibilityHidden(true)
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.caption2)
          .foregroundStyle(MatrixTheme.mutedInk)
        Text(value)
          .font(.headline.monospacedDigit())
          .foregroundStyle(MatrixTheme.ink)
      }
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 12)
    .background(MatrixTheme.surfaceRaised.opacity(0.86), in: .rect(cornerRadius: 14))
    .overlay {
      RoundedRectangle(cornerRadius: 14)
        .stroke(MatrixTheme.separator, lineWidth: 1)
    }
    .accessibilityElement(children: .combine)
  }
}
