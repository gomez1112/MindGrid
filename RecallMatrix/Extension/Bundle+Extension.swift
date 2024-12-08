//
//  Bundle+Extension.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation

/// Extends `Bundle` to include a generic method for loading and decoding JSON files.
extension Bundle {
    /// Decodes a JSON file into a model object of type `T`, where `T` conforms to `Decodable`.
    /// - Parameters:
    ///   - fileName: The name of the JSON file to load.
    ///   - type: The type of the model to decode into. By default, it infers the type from the call site.
    ///   - dateDecodingStrategy: The strategy to use for decoding dates within the JSON. Default is `.deferredToDate`.
    ///   - keyDecodingStrategy: The strategy to use for decoding the keys. Default is `.useDefaultKeys`.
    /// - Returns: A `T` object decoded from the JSON file.
    /// - Throws: `fatalError` with a detailed error message if decoding fails at various stages.
    func load<T: Decodable>(_ fileName: String, as type: T.Type = T.self, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        let data: Data
        // Ensure the file exists in the main bundle, else throw a fatal error with a message.
        guard let fileURL = url(forResource: fileName, withExtension: nil) else { fatalError("Could not find \(fileName) in main bundle.")}
        do {
            // Attempt to read the data from the file URL.
            data = try Data(contentsOf: fileURL)
        } catch {
            fatalError("Could not load \(fileName) from main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            // Attempt to decode the data into the specified type `T`.
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Could not decode \(fileURL) from bundle due to missing key '\(key.stringValue)' not found - \(context.debugDescription).")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Could not decode \(fileURL) from bundle due to type mismatch - \(context.debugDescription).")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Could not decode \(fileURL) from bundle due to missing \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Could not decode \(fileURL) from bundle because it appears to be invalid JSON.")
        } catch {
            // General error handling for any other decoding errors.
            fatalError("Failed to decode \(fileURL) from bundle: \(error.localizedDescription)")
        }
    }
}
