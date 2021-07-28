//
//  MatureInterval.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct MatureInterval: Codable {
    private (set) var intervalSeconds: TimeInterval
    
    private init(intervalSeconds: TimeInterval) {
        self.intervalSeconds = intervalSeconds
    }
    
    static func makeFromTimeInterval(intervalSeconds: TimeInterval) -> MatureInterval {
        return MatureInterval(intervalSeconds: intervalSeconds)
    }
}
