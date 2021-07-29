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
    static private (set) var displayRange: [Float] = [1.0, 1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.35, 1.4, 1.45, 1.5]
    
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
        guard validateRange(value: modifier, min: minimum, max: maximum) else {
            return ModifierFactorException.OUT_OF_RANGE
        }
        return ModifierFactorException.OK
    }
}
