//
//  EasyIntervalModifier.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct EasyIntervalModifier: InputValidation, IntervalModifier, Codable {
    static private (set) var minimum: Float = 1.0
    static private (set) var maximum: Float = 1.5
    
    private (set) var intervalModifier: Float
    
    
    private init(modifier: Float) {
        self.intervalModifier = modifier
    }
    
    static func makeFromFloat(modifier: Float) throws -> EasyIntervalModifier {
        let feedback = validateFactorModifier(modifier: modifier)
        guard feedback == .OK else {
            throw feedback
        }
        return EasyIntervalModifier(modifier: modifier)
    }
    
    static func validateFactorModifier(modifier: Float) -> ModifierFactorException {
        guard validateInsideRange(value: modifier, min: minimum, max: maximum) else {
            return ModifierFactorException.OUT_OF_RANGE
        }
        return ModifierFactorException.OK
    }
}
