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
        guard let preset: SchedulePreset = schedulePresetRepository.getSchedulePreset(forId: id) else { return }
        guard !preset.isDefaultPreset else {
            throw SchedulePresetException.DefaultPresetIsImmutable
        }
        schedulePresetRepository.deleteSchedulePreset(id)
    }
    
    func makePreset(presetName: String, learningSteps: LearningSteps, graduationInterval: GraduationInterval, lapseSteps: LapseSteps, lapseSetbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval, easeFactor: EaseFactor, easyFactorModifier: EasyFactorModifier, normalFactorModifier: NormalFactorModifier, hardFactorModifier: HardFactorModifier, lapseFactorModifier: LapseFactorModifier, easyIntervalModifier: EasyIntervalModifier) throws -> SchedulePreset {
        let newPreset = try SchedulePreset(name: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetbackFactor: lapseSetbackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyFactorModifier: easyFactorModifier, normalFactorModifier: normalFactorModifier, hardFactorModifier: hardFactorModifier, lapseFactorModifier: lapseFactorModifier, easyIntervalModifier: easyIntervalModifier)
        schedulePresetRepository.saveSchedulePreset(newPreset)
        return newPreset
    }

    func updatePreset(forId id: UUID, presetName: String, learningSteps: LearningSteps, graduationInterval: GraduationInterval, lapseSteps: LapseSteps, lapseSetbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval, easeFactor: EaseFactor, easyFactorModifier: EasyFactorModifier, normalFactorModifier: NormalFactorModifier, hardFactorModifier: HardFactorModifier, lapseFactorModifier: LapseFactorModifier, easyIntervalModifier: EasyIntervalModifier) throws -> SchedulePreset {
        let currentPreset = try getSchedulePreset(forId: id)
        let updatedPreset = try SchedulePreset(schedulePreset: currentPreset, name: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetbackFactor: lapseSetbackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyFactorModifier: easyFactorModifier, normalFactorModifier: normalFactorModifier, hardFactorModifier: hardFactorModifier, lapseFactorModifier: lapseFactorModifier, easyIntervalModifier: easyIntervalModifier)
        schedulePresetRepository.saveSchedulePreset(updatedPreset)
        return updatedPreset
    }
    
    @discardableResult
    private func getOrAddDefaultSchedulePreset() -> SchedulePreset {
        guard let defaultPreset: SchedulePreset = schedulePresetRepository.getScheduleDefaultPreset() else {
            let newDefaultPreset = SchedulePreset.makeDefaultPreset()
            schedulePresetRepository.saveSchedulePreset(newDefaultPreset)
            return newDefaultPreset
        }
        return defaultPreset
    }
}
