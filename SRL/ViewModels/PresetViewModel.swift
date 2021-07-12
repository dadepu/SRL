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
    
    var presets: Array<SchedulePreset> {
        get {
            let presets: [UUID:SchedulePreset] = schedulePresetService.getAllSchedulePresets()
            let defaultPreset: [SchedulePreset] = [schedulePresetService.getDefaultSchedulePreset()]
            var namedPresets: [SchedulePreset] = []
            for (_, value) in presets {
                if !value.isDefaultPreset {
                    namedPresets.append(value)
                }
            }
            return defaultPreset + namedPresets.sorted() { (lhs:SchedulePreset, rhs:SchedulePreset) -> Bool in
                lhs.name < rhs.name
            }
        }
    }
    
    
    
    init() {
        schedulePresetObserver = schedulePresetService.getModelPublisher().sink(receiveValue: publishChange(_:))
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
    
    private func publishChange(_: Any) {
        self.objectWillChange.send()
    }
}
