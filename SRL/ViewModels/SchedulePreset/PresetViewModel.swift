//
//  PresetViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import Foundation
import Combine

class PresetViewModel: ObservableObject {
    private let schedulePresetService = SchedulePresetService()
    private var schedulePresetObserver: AnyCancellable?
    
    @Published private (set) var presets: [SchedulePreset] = [SchedulePreset]()
    
    
    init() {
        presets = getPresetsInOrder(schedulePresetService.getAllSchedulePresets())
        schedulePresetObserver = schedulePresetService.getModelPublisher().sink(receiveValue: updateLocalPresets)
    }
    
    
    func getPreset(forIndex index: Int) -> SchedulePreset? {
        return presets[index]
    }
    
    func getPresetIndexOrDefault(forId id: UUID) -> Int {
        if let index: Int = presets.firstIndex(where: {preset in preset.id == id}) {
            return index
        }
        return 0
    }
    
    
    
    private func updateLocalPresets(schedulePresets presets: [UUID : SchedulePreset]) {
        self.presets = getPresetsInOrder(presets)
    }
    
    private func getPresetsInOrder(_ presets: [UUID : SchedulePreset]) -> [SchedulePreset] {
        let defaultPreset: SchedulePreset = try! presets.first(where: { (_: UUID, preset: SchedulePreset) throws -> Bool in
            preset.isDefaultPreset
        })!.value
        var namedPresets: [SchedulePreset] = []
        for (_, preset) in presets {
            if !preset.isDefaultPreset {
                namedPresets.append(preset)
            }
        }
        return [defaultPreset] + namedPresets.sorted() { (lhs:SchedulePreset, rhs:SchedulePreset) -> Bool in
            lhs.name < rhs.name
        }
    }
}
