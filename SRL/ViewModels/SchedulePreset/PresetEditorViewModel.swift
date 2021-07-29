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
    
    @Published private (set) var nameFeedback: SchedulePresetNameValidation = .OK
    @Published private (set) var learningStepsFeedback: LearningStepsException = .OK
    @Published private (set) var graduationIntervalFeedback: GraduationIntervalException = .OK
    @Published private (set) var lapseStepsFeedback: LapseStepsException = .OK
    @Published private (set) var minimumIntervalFeedback: MinimumIntervalException = .OK
    
    @Published private (set) var isSaveAble: Bool = false
    
    private var presetObserver: AnyCancellable?
    private var nameFeedbackObserver: AnyCancellable?
    private var learningStepsFeedbackObserver: AnyCancellable?
    private var graduationIntervalFeedbackObserver: AnyCancellable?
    private var lapseStepsFeedbackObserver: AnyCancellable?
    private var minimumIntervalFeedbackObserver: AnyCancellable?
    
    
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
        self.nameFeedbackObserver = $nameFeedback.sink { feedback in self.initializeIsSaveAble(nameFeedback: feedback) }
        self.learningStepsFeedbackObserver = $learningStepsFeedback.sink { feedback in self.initializeIsSaveAble(learningStepsFeedback: feedback) }
        self.graduationIntervalFeedbackObserver = $graduationIntervalFeedback.sink { feedback in self.initializeIsSaveAble(graduationIntervalFeedback: feedback) }
        self.lapseStepsFeedbackObserver = $lapseStepsFeedback.sink { feedback in self.initializeIsSaveAble(lapseStepsFeedback: feedback) }
        self.minimumIntervalFeedbackObserver = $minimumIntervalFeedback.sink { feedback in self.initializeIsSaveAble(minimumIntervalFeedback: feedback) }
    }
    
    func initializePresetNameFeedback(name: String) {
        nameFeedback = SchedulePresetFactory().validatePresetName(name: name)
    }
    
    func initializeLearningStepsFeedback(steps: String) {
        learningStepsFeedback = LearningSteps.validateLearningSteps(inputSteps: steps)
    }
    
    func initializeGraduationIntervalFeedback(interval: String) {
        graduationIntervalFeedback = GraduationInterval.validateGraduationInterval(interval: interval)
    }
    
    func initializeLapseStepsFeedback(steps: String) {
        lapseStepsFeedback = LapseSteps.validateLapseSteps(inputSteps: steps)
    }
    
    func initializeMinimumIntervalFeedback(interval: String) {
        minimumIntervalFeedback = MinimumInterval.validateMinimumInterval(interval: interval)
    }
    
    func initializeIsSaveAble(nameFeedback: SchedulePresetNameValidation? = nil, learningStepsFeedback: LearningStepsException? = nil, graduationIntervalFeedback: GraduationIntervalException? = nil, lapseStepsFeedback: LapseStepsException? = nil, minimumIntervalFeedback: MinimumIntervalException? = nil) {
        let nameFeedback = nameFeedback != nil ? nameFeedback : self.nameFeedback
        let learningStepsFeedback = learningStepsFeedback != nil ? learningStepsFeedback : self.learningStepsFeedback
        let graduationIntervalFeedback = graduationIntervalFeedback != nil ? graduationIntervalFeedback : self.graduationIntervalFeedback
        let lapseStepsFeedback = lapseStepsFeedback != nil ? lapseStepsFeedback : self.lapseStepsFeedback
        let minimumIntervalFeedback = minimumIntervalFeedback != nil ? minimumIntervalFeedback : self.minimumIntervalFeedback
        
        if nameFeedback == .OK, learningStepsFeedback == .OK, graduationIntervalFeedback == .OK,  lapseStepsFeedback == .OK, minimumIntervalFeedback == .OK {
            self.isSaveAble = true
        } else {
            self.isSaveAble = false
        }
    }
    
    func savePreset(presetName: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws {
        let learningSteps = try LearningSteps.makeFromString(stepsMinutes: learningSteps)
        let graduationInterval = try GraduationInterval.makeFromString(intervalMinutes: graduationInterval)
        let lapseSteps = try LapseSteps.makeFromString(stepsMinutes: lapseSteps)
        let lapseSetbackFactor = try LapseSetbackFactor.makeFromFloat(modifier: lapseSetBackFactor)
        let minimumInterval = try MinimumInterval.makeFromString(intervalMinutes: minimumInterval)
        let easeFactor = try EaseFactor.makeFromFloat(easeFactor: easeFactor)
        let easyModifier = try EasyFactorModifier.makeFromFloat(modifier: easyModifier)
        let normalModifier = try NormalFactorModifier.makeFromFloat(modifier: normalModifier)
        let hardModifier = try HardFactorModifier.makeFromFloat(modifier: hardModifier)
        let lapseModifier = try LapseFactorModifier.makeFromFloat(modifier: lapseModifier)
        let easyIntervalModifier = try EasyIntervalModifier.makeFromFloat(modifier: easyIntervalModifier)
        self.schedulePreset = try SchedulePresetService().makePreset(presetName: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetbackFactor: lapseSetbackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyFactorModifier: easyModifier, normalFactorModifier: normalModifier, hardFactorModifier: hardModifier, lapseFactorModifier: lapseModifier, easyIntervalModifier: easyIntervalModifier)
    }
    
    func updatePreset(presetId: UUID, presetName: String, learningSteps: String, graduationInterval: String, lapseSteps: String, lapseSetBackFactor: Float, minimumInterval: String, easeFactor: Float, easyModifier: Float, normalModifier: Float, hardModifier: Float, lapseModifier: Float, easyIntervalModifier: Float) throws {
        let learningSteps = try LearningSteps.makeFromString(stepsMinutes: learningSteps)
        let graduationInterval = try GraduationInterval.makeFromString(intervalMinutes: graduationInterval)
        let lapseSteps = try LapseSteps.makeFromString(stepsMinutes: lapseSteps)
        let lapseSetbackFactor = try LapseSetbackFactor.makeFromFloat(modifier: lapseSetBackFactor)
        let minimumInterval = try MinimumInterval.makeFromString(intervalMinutes: minimumInterval)
        let easeFactor = try EaseFactor.makeFromFloat(easeFactor: easeFactor)
        let easyModifier = try EasyFactorModifier.makeFromFloat(modifier: easyModifier)
        let normalModifier = try NormalFactorModifier.makeFromFloat(modifier: normalModifier)
        let hardModifier = try HardFactorModifier.makeFromFloat(modifier: hardModifier)
        let lapseModifier = try LapseFactorModifier.makeFromFloat(modifier: lapseModifier)
        let easyIntervalModifier = try EasyIntervalModifier.makeFromFloat(modifier: easyIntervalModifier)
        self.schedulePreset = try SchedulePresetService().updatePreset(forId:presetId, presetName: presetName, learningSteps: learningSteps, graduationInterval: graduationInterval, lapseSteps: lapseSteps, lapseSetbackFactor: lapseSetbackFactor, minimumInterval: minimumInterval, easeFactor: easeFactor, easyFactorModifier: easyModifier, normalFactorModifier: normalModifier, hardFactorModifier: hardModifier, lapseFactorModifier: lapseModifier, easyIntervalModifier: easyIntervalModifier)
    }
}
