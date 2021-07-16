//
//  CardFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct CardFactory: FactoringCard {
    private let schedulerService = SchedulerService()
    private let schedulePresetService = SchedulePresetService()
    
    
//    func makeCard(content: CardType, schedulePreset: SchedulePreset) -> Card {
//        let scheduler: Scheduler = schedulerService.getSchedulerFactory().makeScheduler(schedulePreset: schedulePreset)
//        schedulerService.saveScheduler(scheduler)
//        return Card(content: content, scheduler: scheduler)
//    }
    
    
    
    
    
    private func getSchedulePreset(_ preset: SchedulePreset?) -> SchedulePreset {
        if preset == nil {
            return schedulePresetService.getDefaultSchedulePreset()
        }
        return schedulePresetService.getSchedulePresetOrDefault(forId: preset!.id)
    }
}
