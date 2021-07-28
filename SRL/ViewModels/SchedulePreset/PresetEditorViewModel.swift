//
//  PresetEditorViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 27.07.21.
//

import Foundation
import Combine

class PresetEditorViewModel: ObservableObject {
    @Published private (set) var schedulePreset: SchedulePreset?
    
    @Published private (set) var nameInput: String = ""
    @Published private (set) var nameFeedback: SchedulePresetFactoryException.NameValidation = .EMPTY
    @Published private (set) var learningStepsInput: String = ""
    @Published private (set) var learningStepsFeedback: SchedulePresetFactoryException.LearningStepsValidation = .OK
    @Published private (set) var graduationIntervalInput: String = ""
    @Published private (set) var graduationIntervalFeedback: SchedulePresetFactoryException.GraduationIntervalValidation = .EMPTY
    @Published private (set) var lapseStepsInput: String = ""
    @Published private (set) var lapseStepsFeedback: SchedulePresetFactoryException.LapseStepsValidation = .OK
    @Published private (set) var minimumIntervalInput: String = ""
    @Published private (set) var minimumIntervalFeedback: SchedulePresetFactoryException.MinimumIntervalValidation = .EMPTY
    
    @Published private (set) var isSaveAble: Bool = false
    
    private var presetObserver: AnyCancellable?
    private var nameInputObserver: AnyCancellable?
    private var learningStepsInputObserver: AnyCancellable?
    private var graduationIntervalInputObserver: AnyCancellable?
    private var lapseStepsInputObserver: AnyCancellable?
    private var minimumIntervalInputObserver: AnyCancellable?
    
    
    init(preset: SchedulePreset? = nil) {
        if preset != nil {
            self.schedulePreset = preset
        }
        self.presetObserver = SchedulePresetService().getModelPublisher().sink { (presets: [UUID:SchedulePreset]) in
            guard self.schedulePreset != nil, let updatedPreset = presets[self.schedulePreset!.id] else {
                self.schedulePreset = nil
                return
            }
            self.schedulePreset = updatedPreset
        }
        self.nameInputObserver = $nameInput.sink { name in
            self.nameFeedback = SchedulePresetFactory().validatePresetName(name: name)
            self.isSaveAble = self.validateIsSaveAble(nameFeedback: self.nameFeedback, learningStepsFeedback: self.learningStepsFeedback, graduationIntervalFeedback: self.graduationIntervalFeedback, lapseStepsFeedback: self.lapseStepsFeedback, minimumIntervalFeedback: self.minimumIntervalFeedback)
        }
        self.learningStepsInputObserver = $learningStepsInput.sink { steps in
            self.learningStepsFeedback = SchedulePresetFactory().validateLearningSteps(inputSteps: steps)
            self.isSaveAble = self.validateIsSaveAble(nameFeedback: self.nameFeedback, learningStepsFeedback: self.learningStepsFeedback, graduationIntervalFeedback: self.graduationIntervalFeedback, lapseStepsFeedback: self.lapseStepsFeedback, minimumIntervalFeedback: self.minimumIntervalFeedback)
        }
        self.graduationIntervalInputObserver = $graduationIntervalInput.sink { interval in
            self.graduationIntervalFeedback = SchedulePresetFactory().validateGraduationInterval(inputInterval: interval)
            self.isSaveAble = self.validateIsSaveAble(nameFeedback: self.nameFeedback, learningStepsFeedback: self.learningStepsFeedback, graduationIntervalFeedback: self.graduationIntervalFeedback, lapseStepsFeedback: self.lapseStepsFeedback, minimumIntervalFeedback: self.minimumIntervalFeedback)
        }
        self.lapseStepsInputObserver = $lapseStepsInput.sink { steps in
            self.lapseStepsFeedback = SchedulePresetFactory().validateLapseSteps(inputSteps: steps)
            self.isSaveAble = self.validateIsSaveAble(nameFeedback: self.nameFeedback, learningStepsFeedback: self.learningStepsFeedback, graduationIntervalFeedback: self.graduationIntervalFeedback, lapseStepsFeedback: self.lapseStepsFeedback, minimumIntervalFeedback: self.minimumIntervalFeedback)
        }
        self.minimumIntervalInputObserver = $minimumIntervalInput.sink { interval in
            self.minimumIntervalFeedback = SchedulePresetFactory().validateMinimumInterval(inputInterval: interval)
            self.isSaveAble = self.validateIsSaveAble(nameFeedback: self.nameFeedback, learningStepsFeedback: self.learningStepsFeedback, graduationIntervalFeedback: self.graduationIntervalFeedback, lapseStepsFeedback: self.lapseStepsFeedback, minimumIntervalFeedback: self.minimumIntervalFeedback)
        }
    }
    
    func setNameInput(name: String) {
        self.nameInput = name
    }
    
    func setLearningStepsInput(steps: String) {
        self.learningStepsInput = steps
    }
    
    func setGraduationIntervalInput(interval: String) {
        self.graduationIntervalInput = interval
    }
    
    func setLapseStepsInput(steps: String) {
        self.lapseStepsInput = steps
    }
    
    func setMinimumIntervalInput(interval: String) {
        self.minimumIntervalInput = interval
    }
    
    func savePreset(presetName: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws {
        let _ = try SchedulePresetService().makePreset(presetName: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetBackFactor: lapseSetBackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyModifier: easyModifier, normalModifier: normalModifier, hardModifier: hardModifier, lapseModifier: lapseModifier, easyIntervalModifier: easyIntervalModifier)
    }
    
    func updatePreset(presetName: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws {
        guard let preset = self.schedulePreset else {
            throw SchedulePresetException.EntityNotFound
        }
        self.schedulePreset = try SchedulePresetService().updatePreset(forId: preset.id, presetName: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetBackFactor: lapseSetBackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyModifier: easyModifier, normalModifier: normalModifier, hardModifier: hardModifier, lapseModifier: lapseModifier, easyIntervalModifier: easyIntervalModifier)
    }
    
    private func validateIsSaveAble(nameFeedback: SchedulePresetFactoryException.NameValidation, learningStepsFeedback: SchedulePresetFactoryException.LearningStepsValidation, graduationIntervalFeedback: SchedulePresetFactoryException.GraduationIntervalValidation, lapseStepsFeedback: SchedulePresetFactoryException.LapseStepsValidation, minimumIntervalFeedback: SchedulePresetFactoryException.MinimumIntervalValidation) -> Bool {
        guard nameFeedback == .OK else { return false }
        guard learningStepsFeedback == .OK else { return false }
        guard graduationIntervalFeedback == .OK else { return false }
        guard lapseStepsFeedback == .OK else { return false }
        guard minimumIntervalFeedback == .OK else { return false }
        return true
    }
}
