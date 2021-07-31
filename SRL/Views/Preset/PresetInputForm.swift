//
//  PresetInputForm.swift
//  SRL
//
//  Created by Daniel Koellgen on 29.07.21.
//

import SwiftUI

struct PresetInputForm<SaveButton: View>: View {
    @ObservedObject var presetEditorViewModel: PresetEditorViewModel = PresetEditorViewModel()
    
    private let errorColor: Color = .red
    
    @State var formPresetName: String = ""
    @State var formLearningSteps: String = ""
    @State var formGraduationInterval: String = ""
    
    @State var formLapseSteps: String = ""
    @State var formMinimumInterval: String = ""
    
    @State var formEaseFactor: Float = 0
    @State var formEasyModifier: Float = 0
    @State var formNormalModifier: Float = 0
    @State var formHardModifier: Float = 0
    @State var formLapseModifier: Float = 0
    @State var formLapseSetbackModifier: Float = 0
    
    @State var formEasyIntervalModifier: Float = 0
    
    var FormButton: (PresetInputForm) -> SaveButton
    
    init(preset: SchedulePreset, formButton: @escaping (PresetInputForm) -> SaveButton) {
        self.FormButton = formButton
        self._formPresetName = State<String>(wrappedValue: preset.name)
        self._formLearningSteps = State<String>(wrappedValue: preset.learningSteps.toStringMinutes())
        self._formGraduationInterval = State<String>(wrappedValue: preset.graduationInterval.toStringMinutes())
        self._formLapseSteps = State<String>(wrappedValue: preset.lapseSteps.toStringMinutes())
        self._formLapseSetbackModifier = State<Float>(wrappedValue: preset.lapseSetbackFactor.remainingInterval)
        self._formMinimumInterval = State<String>(wrappedValue: preset.minimumInterval.toStringMinutes())
        self._formEaseFactor = State<Float>(wrappedValue: preset.easeFactor.easeFactor)
        self._formEasyModifier = State<Float>(wrappedValue: preset.easyFactorModifier.factorModifier)
        self._formNormalModifier = State<Float>(wrappedValue: preset.normalFactorModifier.factorModifier)
        self._formHardModifier = State<Float>(wrappedValue: preset.hardFactorModifier.factorModifier)
        self._formLapseModifier = State<Float>(wrappedValue: preset.lapseFactorModifier.factorModifier)
        self._formEasyIntervalModifier = State<Float>(wrappedValue: preset.easyIntervalModifier.intervalModifier)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Preset"),
                    footer: displaySectionError([presetEditorViewModel.nameFeedback.description]))
            {
                TextField("Preset Name", text: $formPresetName)
                    .foregroundColor(presetEditorViewModel.nameFeedback == .OK ? .primary : errorColor)
                    .disableAutocorrection(true)
                    .onChange(of: formPresetName, perform: { presetName in
                        presetEditorViewModel.initializePresetNameFeedback(name: presetName)
                    })
            }
            Section(header: Text("Learning Phase"),
                    footer: displaySectionError([presetEditorViewModel.learningStepsFeedback.description, presetEditorViewModel.graduationIntervalFeedback.description]))
            {
                TextField("Learning Steps", text: $formLearningSteps)
                    .foregroundColor(presetEditorViewModel.learningStepsFeedback == .OK ? .primary : errorColor)
                    .disableAutocorrection(true)
                    .onChange(of: formLearningSteps, perform: { learningSteps in
                        presetEditorViewModel.initializeLearningStepsFeedback(steps: learningSteps)
                    })
                TextField("Graduation Interval", text: $formGraduationInterval)
                    .foregroundColor(presetEditorViewModel.graduationIntervalFeedback == .OK ? .primary : errorColor)
                    .disableAutocorrection(true)
                    .onChange(of: formGraduationInterval, perform: { graduationInterval in
                        presetEditorViewModel.initializeGraduationIntervalFeedback(interval: graduationInterval)
                    })
            }
            Section(header: Text("Lapses"),
                    footer: displaySectionError([presetEditorViewModel.lapseStepsFeedback.description, presetEditorViewModel.minimumIntervalFeedback.description]))
            {
                    TextField("Lapse Steps", text: $formLapseSteps)
                        .foregroundColor(presetEditorViewModel.lapseStepsFeedback == .OK ? .primary : errorColor)
                        .disableAutocorrection(true)
                        .onChange(of: formLapseSteps, perform: { lapseSteps in
                            presetEditorViewModel.initializeLapseStepsFeedback(steps: lapseSteps)
                        })
                    Picker(selection: $formLapseSetbackModifier, label: Text("Lapse Setback Modifier")) {
                        ForEach(LapseSetbackFactor.displayRange, id: \.self) { i in
                            Text("\(i, specifier: "%.2f")").tag(i)
                        }
                    }
                    TextField("Minimum Interval", text: $formMinimumInterval)
                        .foregroundColor(presetEditorViewModel.minimumIntervalFeedback == .OK ? .primary : errorColor)
                        .disableAutocorrection(true)
                        .onChange(of: formMinimumInterval, perform: { minimumInterval in
                            presetEditorViewModel.initializeMinimumIntervalFeedback(interval: minimumInterval)
                        })
                }
            Section(header: Text("Ease-Factor Modifier")) {
                Picker(selection: $formEaseFactor, label: Text("Ease Factor")) {
                    ForEach(EaseFactor.displayRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formEasyModifier, label: Text("Easy Modifier")) {
                    ForEach(EasyFactorModifier.displayRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formNormalModifier, label: Text("Normal Modifier")) {
                    ForEach(NormalFactorModifier.displayRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formHardModifier, label: Text("Hard Modifier")) {
                    ForEach(HardFactorModifier.displayRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
                Picker(selection: $formLapseModifier, label: Text("Lapse Modifier")) {
                    ForEach(LapseFactorModifier.displayRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
            }
            Section(header: Text("Interval Modifier")) {
                Picker(selection: $formEasyIntervalModifier, label: Text("Easy Interval Modifier")) {
                    ForEach(EasyIntervalModifier.displayRange, id: \.self) { i in
                        Text("\(i, specifier: "%.2f")").tag(i)
                    }
                }
            }
            FormButton(self)
        }
        .listStyle(GroupedListStyle())
//        .listStyle(InsetGroupedListStyle())
    }
    
    private func displaySectionError(_ messages: [String]) -> some View {
        let filteredMessages = messages.filter { message in !message.isEmpty }
        let message = !filteredMessages.isEmpty ? filteredMessages[0] : ""
        return Text(message).foregroundColor(.red)
    }
}
