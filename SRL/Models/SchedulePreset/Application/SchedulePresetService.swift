//
//  SchedulePresetService.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetService {
    private let schedulePresetRepository = SchedulePresetRepository.getInstance()
    
    
    func getAllSchedulePresets() -> [UUID:SchedulePreset] {
        let _ = getOrAddDefaultSchedulePreset()
        return schedulePresetRepository.getAllSchedulePresets()
    }
    
    func getSchedulePreset(forId id: UUID) -> SchedulePreset? {
        return schedulePresetRepository.getSchedulePreset(forId: id)
    }
    
    func getSchedulePresetOrDefault(forId id: UUID) -> SchedulePreset {
        if let preset: SchedulePreset = schedulePresetRepository.getSchedulePreset(forId: id) {
            return preset
        } else {
            return getOrAddDefaultSchedulePreset()
        }
    }
    
    func getDefaultSchedulePreset() -> SchedulePreset {
        return getOrAddDefaultSchedulePreset()
    }
    
    func saveSchedulePreset(_ preset: SchedulePreset) {
        schedulePresetRepository.saveSchedulePreset(preset)
    }
    
    func deleteSchedulePreset(forId id: UUID) throws {
        if let preset: SchedulePreset = schedulePresetRepository.getSchedulePreset(forId: id) {
            if preset.isDefaultPreset {
                throw SchedulePresetException.defaultPresetIsImmutable
            }
            schedulePresetRepository.deleteSchedulePreset(id)
        }
    }
    
    func deleteAllSchedulePresets() {
        schedulePresetRepository.deleteAllSchedulePresets()
    }
    
    func getSchedulePresetFactory() -> FactoringSchedulePreset {
        return SchedulePresetFactory()
    }
    
    private func getOrAddDefaultSchedulePreset() -> SchedulePreset {
        if let defaultPreset: SchedulePreset = schedulePresetRepository.getScheduleDefaultPreset() {
            return defaultPreset
        } else {
            let factory = SchedulePresetFactory()
            let defaultPreset = factory.newDefaultPreset()
            schedulePresetRepository.saveSchedulePreset(defaultPreset)
            return defaultPreset
        }
    }
}
