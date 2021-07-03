//
//  DeckFactory.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct DeckFactory: FactoringDeck {
    private let schedulePresetService = SchedulePresetService()
    
    func newDeck(name: String, schedulePreset: SchedulePreset?) throws -> Deck {
        return Deck(name: name, schedulePreset: getSchedulePreset(schedulePreset))
    }
    
    private func getSchedulePreset(_ preset: SchedulePreset?) -> SchedulePreset {
        if preset == nil {
            return schedulePresetService.getDefaultSchedulePreset()
        }
        return schedulePresetService.getSchedulePresetOrDefault(forId: preset!.id)
    }
}
