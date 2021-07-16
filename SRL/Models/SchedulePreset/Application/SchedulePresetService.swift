//
//  SchedulePresetService.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePresetService {
    private let schedulePresetRepository = SchedulePresetRepository.getInstance()
    
    
    func getModelPublisher() -> Published<[UUID:SchedulePreset]>.Publisher {
        schedulePresetRepository.$schedulePresets
    }
    
    
    
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
    
    func deleteSchedulePreset(forId id: UUID) throws {
        if let preset: SchedulePreset = schedulePresetRepository.getSchedulePreset(forId: id) {
            if preset.isDefaultPreset {
                throw SchedulePresetException.defaultPresetIsImmutable
            }
            schedulePresetRepository.deleteSchedulePreset(id)
        }
    }
    
//    func makeSchedulePreset() -> SchedulePreset? {
//        
//    }
    
    func deleteAllSchedulePresets() {
        schedulePresetRepository.deleteAllSchedulePresets()
    }
    
    
    
    
    private func getOrAddDefaultSchedulePreset() -> SchedulePreset {
        if let defaultPreset: SchedulePreset = schedulePresetRepository.getScheduleDefaultPreset() {
            return defaultPreset
        } else {
            let defaultPreset = SchedulePresetFactory().newDefaultPreset()
            schedulePresetRepository.saveSchedulePreset(defaultPreset)
            return defaultPreset
        }
    }
}
