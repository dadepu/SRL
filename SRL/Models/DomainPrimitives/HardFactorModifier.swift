//
//  HardFactorModifier.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct HardFactorModifier: InputValidation, FactorModifier, Codable {
    static private (set) var minimum: Float? = -0.25
    static private (set) var maximum: Float? = 0.0
    
    private (set) var factorModifier: Float
    
    
    private init(modifier: Float) {
        self.factorModifier = modifier
    }
    
    static func makeFromFloat(modifier: Float) throws -> HardFactorModifier {
        let feedback = validateFactorModifier(modifier: modifier)
        guard feedback == .OK else {
            throw feedback
        }
        return HardFactorModifier(modifier: modifier)
    }
    
    static func validateFactorModifier(modifier: Float) -> ModifierFactorException {
        guard validateInsideRange(value: modifier, min: minimum, max: maximum) else {
            return ModifierFactorException.OUT_OF_RANGE
        }
        return ModifierFactorException.OK
    }
}
