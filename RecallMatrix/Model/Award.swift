//
//  Award.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: Criterion
    let value: Int
    let image: String
    
    enum Criterion: String, Decodable {
        case sessions
        case accuracy
        case time
        case gridSize
    }
}
