//
//  GraduationInterval.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct GraduationInterval: InputValidation, Codable {
    private (set) var intervalSeconds: TimeInterval
    
    private init(intervalSeconds: TimeInterval) {
        self.intervalSeconds = intervalSeconds
    }
    
    static func makeFromString(intervalMinutes: String) throws -> GraduationInterval {
        let feedback = validateGraduationInterval(interval: intervalMinutes)
        guard feedback == .OK else {
            throw feedback
        }
        let intervalMinutesNumeric = Double(intervalMinutes)!
        let intervalSeconds = intervalMinutesNumeric * 60
        return GraduationInterval(intervalSeconds: intervalSeconds)
    }
    
    static func makeFromTimeInterval(intervalSeconds: TimeInterval) -> GraduationInterval {
        return GraduationInterval(intervalSeconds: intervalSeconds)
    }
    
    static func validateGraduationInterval(interval: String) -> GraduationIntervalException {
        guard !interval.isEmpty else {
            return GraduationIntervalException.EMPTY
        }
        guard let interval = Int(interval) else {
            return GraduationIntervalException.INVALID_PATTERN
        }
        guard interval > 0 else {
            return GraduationIntervalException.NEGATIVE_NUMBER
        }
        return GraduationIntervalException.OK
    }
    
    func toStringMinutes() -> String {
        String(format: "%.0f", intervalSeconds / 60)
    }
}

enum GraduationIntervalException: Error {
    case OK
    case EMPTY
    case INVALID_PATTERN
    case NEGATIVE_NUMBER
}
