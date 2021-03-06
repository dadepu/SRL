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
    static private (set) var displayRange: [Float] = [1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5]
    
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
        guard validateRange(value: factor, min: minimum, max: maximum) else {
            return EaseFactorException.OUT_OF_RANGE
        }
        return EaseFactorException.OK
    }
    
    func appliedFactorModifier(modifier: FactorModifier) throws -> EaseFactor {
        var updatedEaseFactor = self
        updatedEaseFactor.easeFactor = ((self.easeFactor + modifier.factorModifier) * 100).rounded() / 100
        let feedback = EaseFactor.validateEaseFactor(factor: updatedEaseFactor.easeFactor)
        guard feedback == .OK else {
            throw feedback
        }
        return updatedEaseFactor
    }
    
    func appliedFactorModifierOrMinimum(modifier: FactorModifier) -> EaseFactor {
        guard let updatedFactor = try? appliedFactorModifier(modifier: modifier) else {
            return EaseFactor(modifier: EaseFactor.minimum)
        }
        return updatedFactor
    }
}

extension EaseFactor: Equatable {
    static func == (lhs: EaseFactor, rhs: EaseFactor) -> Bool {
        return
            lhs.easeFactor == rhs.easeFactor
    }
}

enum EaseFactorException: Error {
    case OK
    case OUT_OF_RANGE
}
