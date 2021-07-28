//
//  MinimumInterval.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct MinimumInterval: InputValidation, Codable {
    private (set) var intervalSeconds: TimeInterval
    
    
    private init(intervalSeconds: Double) {
        self.intervalSeconds = intervalSeconds
    }
    
    static func makeFromString(intervalMinutes: String) throws -> MinimumInterval {
        let feedback = validateMinimumInterval(interval: intervalMinutes)
        guard feedback == .OK else {
            throw feedback
        }
        let intervalMinutesNumeric = Double(intervalMinutes)!
        let intervalSeconds = intervalMinutesNumeric * 60
        return MinimumInterval(intervalSeconds: intervalSeconds)
    }
    
    static func makeFromTimeInterval(intervalSeconds: TimeInterval) -> MinimumInterval {
        return MinimumInterval(intervalSeconds: intervalSeconds)
    }
    
    static func validateMinimumInterval(interval: String) -> MinimumIntervalException {
        guard !interval.isEmpty else {
            return MinimumIntervalException.EMPTY
        }
        guard let interval = Int(interval) else {
            return MinimumIntervalException.INVALID_PATTERN
        }
        guard interval > 0 else {
            return MinimumIntervalException.NEGATIVE_NUMBER
        }
        return MinimumIntervalException.OK
    }
}

enum MinimumIntervalException: Error {
    case OK
    case EMPTY
    case INVALID_PATTERN
    case NEGATIVE_NUMBER
}
