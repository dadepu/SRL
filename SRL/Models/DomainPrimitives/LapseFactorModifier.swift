//
//  LapseFactorModifier.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct LapseFactorModifier: InputValidation, FactorModifier, Codable {
    static private (set) var minimum: Float? = -0.4
    static private (set) var maximum: Float? = 0.0
    
    private (set) var factorModifier: Float
    
    
    private init(modifier: Float) {
        self.factorModifier = modifier
    }
    
    static func makeFromFloat(modifier: Float) throws -> LapseFactorModifier {
        let feedback = validateFactorModifier(modifier: modifier)
        guard feedback == .OK else {
            throw feedback
        }
        return LapseFactorModifier(modifier: modifier)
    }
    
    static func validateFactorModifier(modifier: Float) -> ModifierFactorException {
        guard validateInsideRange(value: modifier, min: minimum, max: maximum) else {
            return ModifierFactorException.OUT_OF_RANGE
        }
        return ModifierFactorException.OK
    }
}
