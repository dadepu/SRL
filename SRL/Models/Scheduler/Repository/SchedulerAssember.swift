//
//  SchedulerAssember.swift
//  SRL
//
//  Created by Daniel Koellgen on 16.07.21.
//

import Foundation

struct SchedulerAssembler {
    private let schedulePresetService = SchedulePresetService()
    
    func refreshScheduler(_ scheduler: Scheduler) -> Scheduler {
        let updatedSchedulePreset = schedulePresetService.getSchedulePresetOrDefault(forId: scheduler.schedulePreset.id)
        return scheduler.hasSetSchedulePreset(updatedSchedulePreset)
    }
}
