//
//  SchedulePresetFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetFactory: FactoringSchedulePreset {
    
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
    
    
    func validateLearningSteps(steps: String) throws {
        
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
}
