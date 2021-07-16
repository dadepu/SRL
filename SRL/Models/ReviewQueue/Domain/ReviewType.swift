//
//  ReviewType.swift
//  SRL
//
//  Created by Daniel Koellgen on 13.07.21.
//

import Foundation

enum ReviewType {
    case REGULAR
    case LEARNING
    case LAPSING
    case LOCKAHEAD(_ days: Int)
    case ALLCARDS
}

extension ReviewType {
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
}

extension ReviewType: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .REGULAR:
            try container.encode(0, forKey: .rawValue)
        case .LEARNING:
            try container.encode(1, forKey: .rawValue)
        case .LAPSING:
            try container.encode(2, forKey: .rawValue)
        case .LOCKAHEAD(let days):
            try container.encode(3, forKey: .rawValue)
            try container.encode(days, forKey: .associatedValue)
        case .ALLCARDS:
            try container.encode(4, forKey: .rawValue)
        }
    }
}

extension ReviewType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .REGULAR
        case 1:
            self = .LEARNING
        case 2:
            self = .LAPSING
        case 3:
            let content = try container.decode(Int.self, forKey: .associatedValue)
            self = .LOCKAHEAD(content)
        case 4:
            self = .ALLCARDS
        default:
            throw CodingError.unknownValue
        }
    }
}
