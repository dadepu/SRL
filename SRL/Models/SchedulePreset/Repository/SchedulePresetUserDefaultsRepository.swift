//
//  SchedulePresetUserDefaultsRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetUserDefaultsRepository {
    private static let userdefaultsDeckKey = "SchedulePreset.RootAggregate"


    func loadPresets() -> [UUID:SchedulePreset]? {
        let jsonData = UserDefaults.standard.data(forKey: SchedulePresetUserDefaultsRepository.userdefaultsDeckKey)
        if jsonData != nil, let decodedDecks = try? JSONDecoder().decode([UUID:SchedulePreset].self, from: jsonData!) {
            return decodedDecks
        } else {
            return nil
        }
    }

    func savePresets(_ presets: [UUID:SchedulePreset]) {
        let presetsJSON = try? JSONEncoder().encode(presets)
        UserDefaults.standard.set(presetsJSON, forKey: SchedulePresetUserDefaultsRepository.userdefaultsDeckKey)
    }

    func deletePresets() {
        UserDefaults.standard.set("", forKey: SchedulePresetUserDefaultsRepository.userdefaultsDeckKey)
    }
}
