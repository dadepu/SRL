//
//  SchedulePresetFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetFactory {
    
    private (set) var learningStepsRegEx = #"^(\d)+(\s(\d)+)*"#
    private (set) var lapseStepsRegEx = #"^(\d)*(\s(\d)+)*"#
    
    private (set) var easeFactorRange: [Float] = [1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0]
    private (set) var easyModifierRange: [Float] = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4]
    private (set) var normalModifierRange: [Float] = [-0.1, -0.05, 0, 0.05, 0.1, 0.15, 0.2]
    private (set) var hardModifierRange: [Float] = [-0.025, -0.2, -0.15, -0.1, -0.05, 0]
    private (set) var lapseModifierRange: [Float] = [-0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0]
    
    private (set) var easyIntervalModifierRange: [Float] = [1, 1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.35, 1.4, 1.45, 1.5]
    private (set) var lapseSetbackFactorRange: [Float] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
    
    
    
    func newDefaultPreset() -> SchedulePreset {
        return SchedulePreset(name: SchedulePresetConfig.defaultPresetName)
    }
    
    func newPreset(name: String) throws -> SchedulePreset {
        guard validateNameIsNotDefault(name: name) else {
            throw SchedulePresetException.NameConflictsDefaultName
        }
        return SchedulePreset(name: name)
    }
    
    func newPreset(name: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws -> SchedulePreset {
        
        let validName = try getValidPresetName(name: name)
        let validLearningSteps = try getValidLearningSteps(steps: learningSteps)
        let validGraduationInterval = try getValidGraduationInterval(interval: graduationInterval)
        let validLapseSteps = try getValidLapseSteps(steps: lapseSteps)
        let validLapseSetbackFactor = try getValidLapseSetbackFactor(factor: lapseSetBackFactor)
        let validMinimumInterval = try getValidMinimumInterval(interval: minimumInterval)
        let validEaseFactor = try getValidEaseFactor(factor: easeFactor)
        let validEasyModifier = try getValidFactorModifier(factor: easyModifier, reference: easyModifierRange)
        let validNormalModifier = try getValidFactorModifier(factor: normalModifier, reference: normalModifierRange)
        let validHardModifier = try getValidFactorModifier(factor: hardModifier, reference: hardModifierRange)
        let validLapseModifier = try getValidFactorModifier(factor: lapseModifier, reference: lapseModifierRange)
        let validEasyIntervalModifier = try getValidFactorModifier(factor: easyIntervalModifier, reference: easyIntervalModifierRange)
    
        return SchedulePreset(name: validName, learningSteps: validLearningSteps, graduationInterval: validGraduationInterval, lapseSteps: validLapseSteps, lapseSetBackFactor: validLapseSetbackFactor, minimumInterval: validMinimumInterval, easeFactor: validEaseFactor, easyModifier: validEasyModifier, normalModifier: validNormalModifier, hardModifier: validHardModifier, lapseModifier: validLapseModifier, easyIntervalModifier: validEasyIntervalModifier)
    }
    
    func updatePreset(_ preset: SchedulePreset, name: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws -> SchedulePreset {
        
        let validName = try getValidPresetName(name: name)
        let validLearningSteps = try getValidLearningSteps(steps: learningSteps)
        let validGraduationInterval = try getValidGraduationInterval(interval: graduationInterval)
        let validLapseSteps = try getValidLapseSteps(steps: lapseSteps)
        let validLapseSetbackFactor = try getValidLapseSetbackFactor(factor: lapseSetBackFactor)
        let validMinimumInterval = try getValidMinimumInterval(interval: minimumInterval)
        let validEaseFactor = try getValidEaseFactor(factor: easeFactor)
        let validEasyModifier = try getValidFactorModifier(factor: easyModifier, reference: easyModifierRange)
        let validNormalModifier = try getValidFactorModifier(factor: normalModifier, reference: normalModifierRange)
        let validHardModifier = try getValidFactorModifier(factor: hardModifier, reference: hardModifierRange)
        let validLapseModifier = try getValidFactorModifier(factor: lapseModifier, reference: lapseModifierRange)
        let validEasyIntervalModifier = try getValidFactorModifier(factor: easyIntervalModifier, reference: easyIntervalModifierRange)
        
        return SchedulePreset(preset ,name: validName, learningSteps: validLearningSteps, graduationInterval: validGraduationInterval, lapseSteps: validLapseSteps, lapseSetBackFactor: validLapseSetbackFactor, minimumInterval: validMinimumInterval, easeFactor: validEaseFactor, easyModifier: validEasyModifier, normalModifier: validNormalModifier, hardModifier: validHardModifier, lapseModifier: validLapseModifier, easyIntervalModifier: validEasyIntervalModifier)
    }
    
    
    
    private func getValidPresetName(name: String) throws -> String {
        let feedback = validatePresetName(name: name)
        guard feedback == .OK else {
            throw feedback
        }
        return name
    }
    
    private func getValidLearningSteps(steps: String) throws -> [Double] {
        let feedback = validateLearningSteps(inputSteps: steps)
        guard feedback == .OK else {
            throw feedback
        }
        return steps.split(separator: " ").map { subStr in Double(String(subStr))! }
    }
    
    private func getValidGraduationInterval(interval: String) throws -> Double {
        let feedback = validateGraduationInterval(inputInterval: interval)
        guard feedback == .OK else {
            throw feedback
        }
        return Double(interval)!
    }
    
    private func getValidLapseSteps(steps: String) throws -> [Double] {
        let feedback = validateLapseSteps(inputSteps: steps)
        guard feedback == .OK else {
            throw feedback
        }
        return !steps.isEmpty ? steps.split(separator: " ").map { subStr in Double(String(subStr))! } : []
    }
    
    private func getValidLapseSetbackFactor(factor: Float) throws -> Float {
        let feedback = validateLapseSetbackFactor(factor: factor)
        guard feedback == .OK else {
            throw feedback
        }
        return factor
    }
    
    private func getValidMinimumInterval(interval: String) throws -> Double {
        let feedback = validateMinimumInterval(inputInterval: interval)
        guard feedback == .OK else {
            throw feedback
        }
        return Double(interval)!
    }
    
    private func getValidEaseFactor(factor: Float) throws -> Float {
        let feedback = validateEaseFactor(factor: factor)
        guard feedback == .OK else {
            throw feedback
        }
        return factor
    }
    
    private func getValidFactorModifier(factor: Float, reference: [Float]) throws -> Float {
        let feedback = validateFactorModifier(factor: factor, reference: reference)
        guard feedback == .OK else {
            throw feedback
        }
        return factor
    }
 
    func validatePresetName(name: String) -> SchedulePresetFactoryException.NameValidation {
        guard validateNotEmpty(input: name) else {
            return SchedulePresetFactoryException.NameValidation.EMPTY
        }
        guard validateNameIsNotDefault(name: name) else {
            return SchedulePresetFactoryException.NameValidation.CONFLICTS_DEFAULT
        }
        return SchedulePresetFactoryException.NameValidation.OK
    }
    
    func validateLearningSteps(inputSteps: String) -> SchedulePresetFactoryException.LearningStepsValidation {
        guard validateNotEmpty(input: inputSteps) else {
            return SchedulePresetFactoryException.LearningStepsValidation.EMPTY
        }
        guard validateRegEx(input: inputSteps, pattern: {learningStepsRegEx}) else {
            return SchedulePresetFactoryException.LearningStepsValidation.INVALID_PATTERN
        }
        return SchedulePresetFactoryException.LearningStepsValidation.OK
    }
    
    func validateGraduationInterval(inputInterval: String) -> SchedulePresetFactoryException.GraduationIntervalValidation {
        guard validateNotEmpty(input: inputInterval) else {
            return SchedulePresetFactoryException.GraduationIntervalValidation.EMPTY
        }
        guard let interval = Int(inputInterval) else {
            return SchedulePresetFactoryException.GraduationIntervalValidation.INVALID_PATTERN
        }
        guard interval > 0 else {
            return SchedulePresetFactoryException.GraduationIntervalValidation.NEGATIVE_NUMBER
        }
        return SchedulePresetFactoryException.GraduationIntervalValidation.OK
    }
    
    func validateLapseSteps(inputSteps: String) -> SchedulePresetFactoryException.LapseStepsValidation {
        guard isEmpty(input: inputSteps) else {
            return SchedulePresetFactoryException.LapseStepsValidation.OK
        }
        guard validateRegEx(input: inputSteps, pattern: {lapseStepsRegEx}) else {
            return SchedulePresetFactoryException.LapseStepsValidation.INVALID_PATTERN
        }
        return SchedulePresetFactoryException.LapseStepsValidation.OK
    }
    
    func validateLapseSetbackFactor(factor: Float) -> SchedulePresetFactoryException.LapseSetbackFactorValidation {
        guard lapseSetbackFactorRange.contains(factor) else {
            return SchedulePresetFactoryException.LapseSetbackFactorValidation.OUT_OF_RANGE
        }
        return SchedulePresetFactoryException.LapseSetbackFactorValidation.OK
    }
    
    func validateMinimumInterval(inputInterval: String) -> SchedulePresetFactoryException.MinimumIntervalValidation {
        guard validateNotEmpty(input: inputInterval) else {
            return SchedulePresetFactoryException.MinimumIntervalValidation.EMPTY
        }
        guard let interval = Int(inputInterval) else {
            return SchedulePresetFactoryException.MinimumIntervalValidation.INVALID_PATTERN
        }
        guard interval > 0 else {
            return SchedulePresetFactoryException.MinimumIntervalValidation.NEGATIVE_NUMBER
        }
        return SchedulePresetFactoryException.MinimumIntervalValidation.OK
    }
    
    func validateEaseFactor(factor: Float) -> SchedulePresetFactoryException.EaseFactorValidation {
        guard easeFactorRange.contains(factor) else {
            return SchedulePresetFactoryException.EaseFactorValidation.OUT_OF_RANGE
        }
        return SchedulePresetFactoryException.EaseFactorValidation.OK
    }
    
    func validateFactorModifier(factor: Float, reference: [Float]) -> SchedulePresetFactoryException.ModifierFactorValidation {
        guard reference.contains(factor) else {
            return SchedulePresetFactoryException.ModifierFactorValidation.OUT_OF_RANGE
        }
        return SchedulePresetFactoryException.ModifierFactorValidation.OK
    }
    
    
    

    private func validateNameIsNotDefault(name: String) -> Bool {
        name != SchedulePresetConfig.defaultPresetName
    }
    
    private func isEmpty(input: String) -> Bool {
        input.count == 0
    }

    private func validateNotEmpty(input: String) -> Bool {
        input.count > 0
    }
    
    private func validateRegEx(input: String, pattern: () -> String) -> Bool {
        let range = NSRange(location: 0, length: input.count)
        let regex = try! NSRegularExpression(pattern: pattern())
        guard let result = regex.firstMatch(in: input, options: [], range: range), result.range.length == range.length else {
            return false
        }
        return true
    }
}
