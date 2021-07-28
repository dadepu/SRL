//
//  EaseFactor.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct EaseFactor: InputValidation, Codable {
    static private (set) var minimum: Float = 1.5
    static private (set) var maximum: Float?
    
    private (set) var easeFactor: Float
    
    
    private init(modifier: Float) {
        self.easeFactor = modifier
    }
    
    static func makeFromFloat(easeFactor: Float) throws -> EaseFactor {
        let feedback = validateEaseFactor(factor: easeFactor)
        guard feedback == .OK else {
            throw feedback
        }
        return EaseFactor(modifier: easeFactor)
    }
    
    static func validateEaseFactor(factor: Float) -> EaseFactorException {
        guard validateInsideRange(value: factor, min: minimum, max: maximum) else {
            return EaseFactorException.OUT_OF_RANGE
        }
        return EaseFactorException.OK
    }
    
//    func applyFactorModifier(modifier: FactorModifier) -> EaseFactor {
//
//    }
}

enum EaseFactorException: Error {
    case OK
    case OUT_OF_RANGE
}
