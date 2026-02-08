//
//  ChartCard.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct ChartCard<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder let content: () -> Content
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    
    init(title: LocalizedStringKey, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    private var highContrastBackground: Color {
        #if canImport(UIKit)
        return Color(uiColor: .systemBackground).opacity(0.9)
        #elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor).opacity(0.9)
        #else
        return Color.white.opacity(0.9)
        #endif
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
                      ? AnyShapeStyle(highContrastBackground)
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
