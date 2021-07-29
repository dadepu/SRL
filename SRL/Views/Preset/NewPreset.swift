//
//  AddPresetSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct NewPreset: View {
    @Binding var isShowingSheet: Bool
    var preset: SchedulePreset = SchedulePresetService().getDefaultSchedulePreset()
    
    var body: some View {
        NavigationView{
            PresetInputForm<SaveButton>(preset: preset, formButton: { presetForm in
                SaveButton(isShowingSheet: $isShowingSheet, presetInputForm: presetForm)
            })
            .navigationBarTitle(Text("New Preset"))
        }
    }
    
    struct SaveButton: View {
        @Binding var isShowingSheet: Bool
        var presetInputForm: PresetInputForm<SaveButton>

        var body: some View {
            Button(action: {
                do {
                    try presetInputForm.presetEditorViewModel.savePreset(presetName: presetInputForm.formPresetName, learningSteps: presetInputForm.formLearningSteps, graduationInterval: presetInputForm.formGraduationInterval, lapseSteps: presetInputForm.formLapseSteps, lapseSetBackFactor: presetInputForm.formLapseSetbackModifier, minimumInterval: presetInputForm.formMinimumInterval, easeFactor: presetInputForm.formEaseFactor, easyModifier: presetInputForm.formEasyModifier, normalModifier: presetInputForm.formNormalModifier, hardModifier: presetInputForm.formHardModifier, lapseModifier: presetInputForm.formLapseModifier, easyIntervalModifier: presetInputForm.formEasyIntervalModifier)
                    isShowingSheet = false
                } catch {}
            }, label: {
                HStack {
                    Spacer()
                    Text("Save Preset")
                        .bold()
                    Spacer()
                }
            })
        }
    }
}
