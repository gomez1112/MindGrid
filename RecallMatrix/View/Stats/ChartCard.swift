//
//  ChartCard.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import SwiftUI

struct ChartCard<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder let content: () -> Content
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    
    init(title: LocalizedStringKey, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            content()
                .padding(.top, 5)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorSchemeContrast == .increased
                      ? AnyShapeStyle(Color(.systemBackground).opacity(0.9))
                      : AnyShapeStyle(.ultraThinMaterial))
        }
        .overlay {
            if colorSchemeContrast == .increased {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary.opacity(0.2), lineWidth: 1)
            }
        }
        .frame(minHeight: 300)
    }
}
