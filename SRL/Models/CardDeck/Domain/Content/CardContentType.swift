//
//  ContentType.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

enum CardContentType {
    case TEXT(content: TextContent)
    case IMAGE(content: ImageContent)
    case TYPING(content: TypingContent)
}

extension CardContentType {
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
}

extension CardContentType: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .TEXT(let content):
            try container.encode(0, forKey: .rawValue)
            try container.encode(content, forKey: .associatedValue)
        case .IMAGE(let content):
            try container.encode(1, forKey: .rawValue)
            try container.encode(content, forKey: .associatedValue)
        case .TYPING(let content):
            try container.encode(2, forKey: .rawValue)
            try container.encode(content, forKey: .associatedValue)
        }
    }
}

extension CardContentType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let content = try container.decode(TextContent.self, forKey: .associatedValue)
            self = .TEXT(content: content)
        case 1:
            let content = try container.decode(ImageContent.self, forKey: .associatedValue)
            self = .IMAGE(content: content)
        case 2:
            let content = try container.decode(TypingContent.self, forKey: .associatedValue)
            self = .TYPING(content: content)
        default:
            throw CodingError.unknownValue
        }
    }
}
