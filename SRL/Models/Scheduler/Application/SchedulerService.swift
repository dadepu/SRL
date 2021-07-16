//
//  SchedulerService.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation

struct SchedulerService {
    private let schedulerRepository = SchedulerRepository.getInstance()
    
    
    func getModelPublisher() -> Published<[UUID:Scheduler]>.Publisher {
        schedulerRepository.$schedulers
    }
    
    
    func getScheduler(forId id: UUID) -> Scheduler? {
        schedulerRepository.getScheduler(forId: id)
    }
    
    func setPreset(forId id: UUID, withId presetId: UUID) {
        if let scheduler = getScheduler(forId: id), let preset = SchedulePresetService().getSchedulePreset(forId: presetId) {
            schedulerRepository.saveScheduler(scheduler.hasSetSchedulePreset(preset))
        }
    }
}
