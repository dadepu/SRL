//
//  CardType.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

enum CardType {
    case DEFAULT(content: DefaultCardContent)
    case TYPING(content: TypingContent)
}

extension CardType {
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
}

extension CardType: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .DEFAULT(let content):
            try container.encode(0, forKey: .rawValue)
            try container.encode(content, forKey: .associatedValue)
        case .TYPING(let content):
            try container.encode(1, forKey: .rawValue)
            try container.encode(content, forKey: .associatedValue)
        }
    }
}

extension CardType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let content = try container.decode(DefaultCardContent.self, forKey: .associatedValue)
            self = .DEFAULT(content: content)
        case 1:
            let content = try container.decode(TypingContent.self, forKey: .associatedValue)
            self = .TYPING(content: content)
        default:
            throw CodingError.unknownValue
        }
    }
}
