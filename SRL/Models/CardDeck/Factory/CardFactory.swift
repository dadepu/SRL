//
//  CardFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct CardFactory: FactoringCard {
    private let schedulePresetService = SchedulePresetService()
    
    func newCard(content: CardType, schedule: SchedulePreset?) throws -> Card {
        return Card(content: content, preset: getSchedulePreset(schedule))
    }
    
    private func getSchedulePreset(_ preset: SchedulePreset?) -> SchedulePreset {
        if preset == nil {
            return schedulePresetService.getDefaultSchedulePreset()
        }
        return schedulePresetService.getSchedulePresetOrDefault(forId: preset!.id)
    }
}
