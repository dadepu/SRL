//
//  PresetEditView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct EditPresetView: View {
    @ObservedObject private var presetViewModel = PresetViewModel()
    private var preset: SchedulePreset
    
    
    init(preset: SchedulePreset) {
        self.preset = preset
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
