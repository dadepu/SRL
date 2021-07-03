//
//  SchedulePresetFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetFactory: FactoringSchedulePreset {
    private var schedulePresetConfig: SchedulePresetConfig = SchedulePresetConfig()
    
    
    func newDefaultPreset() -> SchedulePreset {
        return SchedulePreset(name: "Default")
    }
    
    func newPreset(name: String) throws -> SchedulePreset {
        try validateNameIsNotDefault(name: name)
        return SchedulePreset(name: name)
    }
    
    
    private func validateNameIsNotDefault(name: String) throws {
        if name == schedulePresetConfig.defaultPresetName {
            throw SchedulePresetException.nameConflictsDefaultName
        }
    }
}
