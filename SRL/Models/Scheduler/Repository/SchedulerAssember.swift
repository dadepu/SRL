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
        var scheduler = scheduler
        if let updatedSchedulePreset = presets[scheduler.schedulePreset.id] {
            scheduler.setSchedulePreset(updatedSchedulePreset)
        } else {
            scheduler.setSchedulePreset(schedulePresetService.getDefaultSchedulePreset())
        }
        return scheduler
    }
}
