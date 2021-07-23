//
//  SchedulePresetFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetFactory {
    
    private (set) var oneNumberRequiredRegEx = #"^(\d)+"#
    private (set) var learningStepsRegEx = #"^(\d)+(\s(\d)+)*"#
    private (set) var lapseStepsRegEx = #"^(\d)*(\s(\d)+)*"#
    
    
    
    func newDefaultPreset() -> SchedulePreset {
        return SchedulePreset(name: SchedulePresetConfig.defaultPresetName)
    }
    
    func newPreset(name: String) throws -> SchedulePreset {
        try validateNameIsNotDefault(name: name)
        return SchedulePreset(name: name)
    }
    
    func validatePresetName(steps: String) {
        
    }
    
    func validateLearningSteps(steps: String) {
        
    }
    
    func validateGraduationInterval(interval: String) {
        
    }
    
    func validateLapseSteps(steps: String) {
        
    }
    
    func validateMinimumInterval(interval: String) {
        
    }
    
    func validateEaseFactor(factor: String) {
        
    }
    
    func validateReviewFactorModifier(modifier: String) {
        
    }
    
    func validateReviewIntervalModifier(modifier: String) {
        
    }
    
    func validateNameIsNotDefault(name: String) throws {
        if name == SchedulePresetConfig.defaultPresetName {
            throw SchedulePresetException.nameConflictsDefaultName
        }
    }
    
    enum NameValidation {
        case OK
        case EMPTY
        case CONFLICTS_DEFAULT
    }
    
    enum LearningStepsValidation {
        case OK
        case INVALID_PATTERN
        case NEGATIVE_NUMBER
    }
    
    enum GraduationIntervalValidation {
        case OK
        case EMPTY
        case INVALID_PATTERN
        case NEGATIVE_NUMBER
    }
    
    enum LapseStepsValidation {
        case OK
        case INVALID_PATTERN
        case NEGATIVE_NUMBER
    }
    
    enum MinimumIntervalValidation {
        case OK
        case INVALID_PATTERN
        case NEGATIVE_NUMBER
    }
    
    enum EaseFactorValidation {
        case OK
        case EMPTY
        case INVALID_PATTERN
        case BELOW_MINIMUM
    }
    
    enum ReviewFactorModifierValidation {
        case OK
        case INVALID_PATTERN
    }
}
