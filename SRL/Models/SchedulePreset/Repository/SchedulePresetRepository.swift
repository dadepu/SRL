//
//  SchedulePresetRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation
import Combine

class SchedulePresetRepository {
    private static var instance: SchedulePresetRepository?
    private (set) var userDefaultsRepository = SchedulePresetUserDefaultsRepository()
    
    @Published private (set) var schedulePresets: [UUID:SchedulePreset] = [UUID:SchedulePreset]()
    private var dataSaving: AnyCancellable?
    
    
    
    static func getInstance() -> SchedulePresetRepository {
        if SchedulePresetRepository.instance == nil {
            SchedulePresetRepository.instance = SchedulePresetRepository()
        }
        return SchedulePresetRepository.instance!
    }
    
    private init() {
        if let presets: [UUID:SchedulePreset] = userDefaultsRepository.loadPresets() {
            schedulePresets = presets
        }
        dataSaving = $schedulePresets.sink(receiveValue: saveWithUserDefaultsRepository)
    }
    
    
    
    
    func getAllSchedulePresets() -> [UUID:SchedulePreset] {
        schedulePresets
    }
    
    func getSchedulePreset(forId id: UUID) -> SchedulePreset? {
        schedulePresets[id]
    }
    
    func getScheduleDefaultPreset() -> SchedulePreset? {
        for i in schedulePresets {
            if i.value.isDefaultPreset {
                return i.value
            }
        }
        return nil
    }
    
    func saveSchedulePreset(_ preset: SchedulePreset) {
        schedulePresets[preset.id] = preset
    }
    
    func deleteSchedulePreset(_ id: UUID) {
        schedulePresets.removeValue(forKey: id)
    }
    
    func deleteAllSchedulePresets() {
        schedulePresets = [UUID:SchedulePreset]()
    }
    
    
    
    
    private func saveWithUserDefaultsRepository(presets: [UUID:SchedulePreset]) {
        userDefaultsRepository.savePresets(presets)
    }
}
