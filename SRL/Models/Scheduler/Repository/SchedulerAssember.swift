//
//  SchedulerAssember.swift
//  SRL
//
//  Created by Daniel Koellgen on 16.07.21.
//

import Foundation

struct SchedulerAssembler {
    private let schedulePresetService = SchedulePresetService()
    
    func refreshScheduler(_ scheduler: Scheduler, withSchedulePresets presets: [UUID:SchedulePreset]) -> Scheduler {
        if let updatedSchedulePreset = presets[scheduler.schedulePreset.id] {
            return scheduler.hasSetSchedulePreset(updatedSchedulePreset)
        } else {
            return scheduler.hasSetSchedulePreset(schedulePresetService.getDefaultSchedulePreset())
        }
    }
}
