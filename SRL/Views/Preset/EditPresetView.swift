//
//  PresetEditView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct EditPresetView: View {
    @ObservedObject private var presetViewModel = PresetViewModel()
    @ObservedObject private var presetEditorViewModel: PresetEditorViewModel = PresetEditorViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var formPresetName: String = ""
    @State private var formLearningSteps: String = ""
    @State private var formGraduationInterval: String = ""
    
    @State private var formLapseSteps: String = ""
    @State private var formMinimumInterval: String = ""
    
    @State private var formEaseFactor: Float = 2
    @State private var formEasyModifier: Float = 0
    @State private var formNormalModifier: Float = 0
    @State private var formHardModifier: Float = 0
    @State private var formLapseModifier: Float = 0
    @State private var formLapseSetbackModifier: Float = 0
    
    @State private var formEasyIntervalModifier: Float = 0
    
    
    init(preset: SchedulePreset, presetViewModel: PresetViewModel) {
        self.presetViewModel = presetViewModel
        self.presetEditorViewModel = PresetEditorViewModel(preset: preset)
        
        guard let preset = presetEditorViewModel.schedulePreset else {
            return
        }
        self._formPresetName = State<String>(wrappedValue: preset.name)
        self._formLearningSteps = State<String>(wrappedValue: preset.learningStepsInSeconds.map({(step: Double) in String(format: "%.0f", step)}).reduce("", {x, y in x + (x.isEmpty ? y : " " + y)}))
        self._formGraduationInterval = State<String>(wrappedValue: String(format: "%.0f", preset.graduationIntervalInSeconds))
        self._formLapseSteps = State<String>(wrappedValue: preset.lapseStepsInSeconds.map({(step: Double) in String(format: "%.0f", step)}).reduce("", {x, y in x + (x.isEmpty ? y : " " + y)}))
        self._formMinimumInterval = State<String>(wrappedValue: String(format: "%.0f", preset.minimumIntervalInSeconds))
        self._formEaseFactor = State<Float>(wrappedValue: preset.easeFactor)
        self._formEasyModifier = State<Float>(wrappedValue: preset.easyFactorModifier)
        self._formNormalModifier = State<Float>(wrappedValue: preset.normalFactorModifier)
        self._formHardModifier = State<Float>(wrappedValue: preset.hardFactorModifier)
        self._formLapseModifier = State<Float>(wrappedValue: preset.lapseFactorModifier)
        self._formLapseSetbackModifier = State<Float>(wrappedValue: preset.lapseSetBackFactor)
        self._formEasyIntervalModifier = State<Float>(wrappedValue: preset.easyIntervalModifier)
        
        print(preset.lapseStepsInSeconds)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Preset"), footer: displaySectionErrorMessage([presetEditorViewModel.nameFeedback.description])) {
                TextField("Preset Name", text: $formPresetName)
                    .foregroundColor(presetEditorViewModel.nameFeedback == .OK ? .primary : .red)
                    .disableAutocorrection(true)
                    .onChange(of: formPresetName, perform: { value in
                        presetEditorViewModel.setNameInput(name: value)
                    })
            }
            Section(header: Text("Learning Phase"), footer: displaySectionErrorMessage([presetEditorViewModel.learningStepsFeedback.description, presetEditorViewModel.graduationIntervalFeedback.description])) {
                TextField("Learning Steps", text: $formLearningSteps)
                    .foregroundColor(presetEditorViewModel.learningStepsFeedback == .OK ? .primary : .red)
                    .disableAutocorrection(true)
                    .onChange(of: formLearningSteps, perform: { value in
                        presetEditorViewModel.setLearningStepsInput(steps: value)
                    })
                TextField("Graduation Interval", text: $formGraduationInterval)
                    .foregroundColor(presetEditorViewModel.graduationIntervalFeedback == .OK ? .primary : .red)
                    .disableAutocorrection(true)
                    .onChange(of: formGraduationInterval, perform: { value in
                        presetEditorViewModel.setGraduationIntervalInput(interval: value)
                    })
            }
            Section(header: Text("Lapses"), footer: displaySectionErrorMessage([presetEditorViewModel.lapseStepsFeedback.description, presetEditorViewModel.minimumIntervalFeedback.description])) {
                TextField("Lapse Steps", text: $formLapseSteps)
                    .foregroundColor(presetEditorViewModel.lapseStepsFeedback == .OK ? .primary : .red)
                    .disableAutocorrection(true)
                    .onChange(of: formLapseSteps, perform: { value in
                        presetEditorViewModel.setLapseStepsInput(steps: value)
                    })
                Picker(selection: $formLapseSetbackModifier, label: Text("Lapse Setback Modifier")) {
                    ForEach(SchedulePresetFactory().lapseSetbackFactorRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                TextField("Minimum Interval", text: $formMinimumInterval)
                    .foregroundColor(presetEditorViewModel.minimumIntervalFeedback == .OK ? .primary : .red)
                    .disableAutocorrection(true)
                    .onChange(of: formMinimumInterval, perform: { value in
                        presetEditorViewModel.setMinimumIntervalInput(interval: value)
                    })
            }
            Section(header: Text("Ease-Factor Modifier")) {
                Picker(selection: $formEaseFactor, label: Text("Ease Factor")) {
                    ForEach(SchedulePresetFactory().easeFactorRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formEasyModifier, label: Text("Easy Modifier")) {
                    ForEach(SchedulePresetFactory().easyModifierRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formNormalModifier, label: Text("Normal Modifier")) {
                    ForEach(SchedulePresetFactory().normalModifierRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formHardModifier, label: Text("Hard Modifier")) {
                    ForEach(SchedulePresetFactory().hardModifierRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formLapseModifier, label: Text("Lapse Modifier")) {
                    ForEach(SchedulePresetFactory().hardModifierRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                
            }
            Section(header: Text("Interval Modifier")) {
                Picker(selection: $formEasyIntervalModifier, label: Text("Easy Interval Modifier")) {
                    ForEach(SchedulePresetFactory().easyIntervalModifierRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
            }
            Button(action: {
                try? presetEditorViewModel.updatePreset(presetName: presetEditorViewModel.nameInput, learningSteps: presetEditorViewModel.learningStepsInput, graduationInterval: presetEditorViewModel.graduationIntervalInput, lapseSteps: presetEditorViewModel.lapseStepsInput, lapseSetBackFactor: formLapseSetbackModifier, minimumInterval: presetEditorViewModel.minimumIntervalInput, easeFactor: formEaseFactor, easyModifier: formEasyModifier, normalModifier: formNormalModifier, hardModifier: formHardModifier, lapseModifier: formLapseModifier, easyIntervalModifier: formEasyIntervalModifier)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Spacer()
                    Text("Save Preset")
                        .bold()
                    Spacer()
                }
            }).disabled(!presetEditorViewModel.isSaveAble)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private func displaySectionErrorMessage(_ messages: [String]) -> some View {
        let filteredMessages = messages.filter { message in !message.isEmpty }
        let message = !filteredMessages.isEmpty ? filteredMessages[0] : ""
        return Text(message).foregroundColor(.red)
    }
}
