//
//  PresetEditView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct EditPreset: View {
    @Environment(\.presentationMode) var presentationMode
    var preset: SchedulePreset
    
    
    var body: some View {
        PresetInputForm<SaveButton>(preset: preset, formButton: { presetForm in
            SaveButton(preset: self.preset, presetInputForm: presetForm, presentationMode: self.presentationMode)
        })
        .navigationBarTitle(preset.name, displayMode: .inline)
    }
    
    struct SaveButton: View {
        var preset: SchedulePreset
        var presetInputForm: PresetInputForm<SaveButton>
        @Binding var presentationMode: PresentationMode
        
        var body: some View {
            Button(action: {
                do {
                    try presetInputForm.presetEditorViewModel.updatePreset(presetId: preset.id, presetName: presetInputForm.formPresetName, learningSteps: presetInputForm.formLearningSteps, graduationInterval: presetInputForm.formGraduationInterval, lapseSteps: presetInputForm.formLapseSteps, lapseSetBackFactor: presetInputForm.formLapseSetbackModifier, minimumInterval: presetInputForm.formMinimumInterval, easeFactor: presetInputForm.formEaseFactor, easyModifier: presetInputForm.formEasyModifier, normalModifier: presetInputForm.formNormalModifier, hardModifier: presetInputForm.formHardModifier, lapseModifier: presetInputForm.formLapseModifier, easyIntervalModifier: presetInputForm.formEasyIntervalModifier)
                    presentationMode.dismiss()
                } catch {}
            }, label: {
                HStack {
                    Spacer()
                    Text("Save Preset")
                        .bold()
                    Spacer()
                }
            }).disabled(!presetInputForm.presetEditorViewModel.isSaveAble || preset.isDefaultPreset)
        }
    }
}
