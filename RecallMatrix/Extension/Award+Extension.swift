//
//  Award+Extension.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation

/// Extends the `Award` type with functionality for loading JSON data containing award details.
extension Award {
    /// Loads an array of `Award` objects from a JSON file named "Awards.json" located in the main bundle.
    static let awards: [Award] = Bundle.main.load("Awards.json")
    /// Represents the first `Award` object loaded from the JSON data.
    /// Note: This line assumes that the JSON file is non-empty and contains at least one `Award` object.
    static let award = awards[0]
}
