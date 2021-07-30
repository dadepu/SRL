//
//  PresetViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import Foundation
import Combine

class PresetViewModel: ObservableObject {
    @Published private (set) var orderedPresets: [SchedulePreset] = []
    @Published private (set) var presetOrder: (SchedulePreset, SchedulePreset) -> Bool = PresetViewModel.sortByNameDefaultFirst()
    
    private let schedulePresetService = SchedulePresetService()
    private var schedulePresetObserver: AnyCancellable?
    
    
    init() {
        initializeSortedPresets(schedulePresetService.getAllSchedulePresets(), sortOrder: presetOrder)
        schedulePresetObserver = schedulePresetService.getModelPublisher().sink { schedulePresets in
            self.initializeSortedPresets(schedulePresets, sortOrder: self.presetOrder)
        }
    }
    
    private func initializeSortedPresets(_ presets: [UUID:SchedulePreset], sortOrder: (SchedulePreset, SchedulePreset) -> Bool) {
        orderedPresets = presets.map { key, value in value }.sorted(by: sortOrder)
    }
    
    func getPresetOrDefaultIndex(forId id: UUID) -> Int {
        guard let presetIndex = orderedPresets.firstIndex(where: {preset in preset.id == id}) else {
            return orderedPresets.firstIndex { preset in preset.isDefaultPreset }!
        }
        return presetIndex
    }
    
    static func getDefaultPreset() -> SchedulePreset {
        SchedulePresetService().getDefaultSchedulePreset()
    }
    
    
    
    private static func sortByNameDefaultFirst() -> (SchedulePreset, SchedulePreset) -> Bool {
        { lhs, rhs in lhs.isDefaultPreset || lhs.name < rhs.name && !rhs.isDefaultPreset }
    }
}
