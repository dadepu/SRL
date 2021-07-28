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
        getOrAddDefaultSchedulePreset()
        return schedulePresetRepository.getAllSchedulePresets()
    }
    
    func getSchedulePreset(forId id: UUID) throws ->  SchedulePreset {
        guard let preset = schedulePresetRepository.getSchedulePreset(forId: id) else {
            throw SchedulePresetException.EntityNotFound
        }
        return preset
    }
    
    func getSchedulePresetOrDefault(forId id: UUID) -> SchedulePreset {
        guard let preset: SchedulePreset = schedulePresetRepository.getSchedulePreset(forId: id) else {
            return getOrAddDefaultSchedulePreset()
        }
        return preset
    }
    
    func getDefaultSchedulePreset() -> SchedulePreset {
        return getOrAddDefaultSchedulePreset()
    }
    
    func deleteSchedulePreset(forId id: UUID) throws {
        guard let preset: SchedulePreset = schedulePresetRepository.getSchedulePreset(forId: id) else {
            return
        }
        guard !preset.isDefaultPreset else {
            throw SchedulePresetException.DefaultPresetIsImmutable
        }
        schedulePresetRepository.deleteSchedulePreset(id)
    }
    
    func makePreset(presetName: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws -> SchedulePreset {
        let preset = try SchedulePresetFactory().newPreset(name: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetBackFactor: lapseSetBackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyModifier: easyModifier, normalModifier: normalModifier, hardModifier: hardModifier, lapseModifier: lapseModifier, easyIntervalModifier: easyIntervalModifier)
        schedulePresetRepository.saveSchedulePreset(preset)
        return preset
    }
    
    func updatePreset(forId id: UUID, presetName: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws -> SchedulePreset {
        let preset = try getSchedulePreset(forId: id)
        let updatedPreset = try SchedulePresetFactory().updatePreset(preset, name: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetBackFactor: lapseSetBackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyModifier: easyModifier, normalModifier: normalModifier, hardModifier: hardModifier, lapseModifier: lapseModifier, easyIntervalModifier: easyIntervalModifier)
        schedulePresetRepository.saveSchedulePreset(updatedPreset)
        return updatedPreset
    }
    
    @discardableResult
    private func getOrAddDefaultSchedulePreset() -> SchedulePreset {
        guard let defaultPreset: SchedulePreset = schedulePresetRepository.getScheduleDefaultPreset() else {
            let newDefaultPreset = SchedulePresetFactory().newDefaultPreset()
            schedulePresetRepository.saveSchedulePreset(newDefaultPreset)
            return newDefaultPreset
        }
        return defaultPreset
    }
}
