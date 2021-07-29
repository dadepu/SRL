//
//  NormalFactorModifier.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct NormalFactorModifier: InputValidation, FactorModifier, Codable {
    static private (set) var minimum: Float? = -0.1
    static private (set) var maximum: Float? = 0.2
    static private (set) var displayRange: [Float] = [-0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2]
    
    private (set) var factorModifier: Float
    
    
    private init(modifier: Float) {
        self.factorModifier = modifier
    }
    
    static func makeFromFloat(modifier: Float) throws -> NormalFactorModifier {
        let feedback = validateFactorModifier(modifier: modifier)
        guard feedback == .OK else {
            throw feedback
        }
        return NormalFactorModifier(modifier: modifier)
    }
    
    static func validateFactorModifier(modifier: Float) -> ModifierFactorException {
        guard validateRange(value: modifier, min: minimum, max: maximum) else {
            return ModifierFactorException.OUT_OF_RANGE
        }
        return ModifierFactorException.OK
    }
}
