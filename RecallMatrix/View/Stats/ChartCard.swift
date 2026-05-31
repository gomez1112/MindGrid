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
    
    init(title: LocalizedStringKey, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(MatrixTheme.ink)
            content()
        }
        .matrixPanel(cornerRadius: 20)
        .frame(minHeight: 300)
    }
}
