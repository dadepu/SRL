//
//  LearningState.swift
//  SRL
//
//  Created by Daniel Koellgen on 26.05.21.
//

import Foundation

enum LearningState {
    case LEARNING
    case REVIEW
    case LAPSE
}

extension LearningState {
    enum CodingKeys: String, CodingKey {
            case LEARNING, REVIEW, LAPSE
        }
}

extension LearningState: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .LEARNING:
            try container.encode(true, forKey: .LEARNING)
        case .REVIEW:
            try container.encode(true, forKey: .REVIEW)
        case .LAPSE:
            try container.encode(true, forKey: .LAPSE)
        }
    }
}

extension LearningState: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .LEARNING:
            self = .LEARNING
        case .REVIEW:
            self = .REVIEW
        case .LAPSE:
            self = .LAPSE
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
}

