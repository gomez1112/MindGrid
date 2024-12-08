//
//  PreviewTrait+Extension.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation
import SwiftUI

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static let previewData: Self = .modifier(PreviewData())
}
