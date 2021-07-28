//
//  LapseSetbackFactor.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct LapseSetbackFactor: InputValidation, Codable {
    static private (set) var minimum: Float? = 0.0
    static private (set) var maximum: Float? = 1.0
    
    private (set) var remainingInterval: Float
    
    
    private init(modifier: Float) {
        self.remainingInterval = modifier
    }
    
    static func makeFromFloat(modifier: Float) throws -> LapseSetbackFactor {
        let feedback = validateLapseSetbackFactor(factor: modifier)
        guard feedback == .OK else {
            throw feedback
        }
        return LapseSetbackFactor(modifier: modifier)
    }
    
    static func validateLapseSetbackFactor(factor: Float) -> LapseSetbackFactorException {
        guard validateInsideRange(value: factor, min: minimum, max: maximum) else {
            return LapseSetbackFactorException.OUT_OF_RANGE
        }
        return LapseSetbackFactorException.OK
    }
}

enum LapseSetbackFactorException: Error {
    case OK
    case OUT_OF_RANGE
}
