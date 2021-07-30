//
//  CardSchedulePresetPicker.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct CardSchedulePresetPicker: View {
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var abstractCardViewModel: AbstractCardViewModel
    @State var presetId: UUID
    
    var body: some View {
        Picker(selection: $presetId, label: Text("Scheduler Preset")) {
            ForEach(presetViewModel.orderedPresets) { preset in
                Text(preset.name)
                    .tag(preset.id)
            }
        }.onChange(of: presetId, perform: { presetId in
            abstractCardViewModel.changeSchedulePreset(presetId: presetId)
        })
    }
}
