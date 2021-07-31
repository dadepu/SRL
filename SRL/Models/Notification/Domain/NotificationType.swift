//
//  NotificationSchedules.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation

enum NotificationType {
    case AM
    case PM
}

extension NotificationType {
    enum CodingKeys: String, CodingKey {
            case AM, PM
        }
}

extension NotificationType: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .AM:
            try container.encode(true, forKey: .AM)
        case .PM:
            try container.encode(true, forKey: .PM)
        }
    }
}

extension NotificationType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .AM:
            self = .AM
        case .PM:
            self = .PM
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
