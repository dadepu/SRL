//
//  SchedulePreset.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePreset: Identifiable, Codable {
    private (set) static var defaultPresetName: String = "Default"
    
    private (set) var id: UUID = UUID()
    private (set) var name: String
    
    private (set) var matureInterval: MatureInterval = MatureInterval.makeFromTimeInterval(intervalSeconds: 2419200) 
    private (set) var learningSteps: LearningSteps = LearningSteps.makeFromTimeInterval(stepsSeconds: [64800, 496800, 1274400]) // 1d, 6d, 15d
    private (set) var graduationInterval: GraduationInterval = GraduationInterval.makeFromTimeInterval(intervalSeconds: 2592000) // 30d
    
    private (set) var lapseSteps: LapseSteps = LapseSteps.makeFromTimeInterval(stepsSeconds: [64800, 496800]) // 1d, 6d
    private (set) var lapseSetbackFactor: LapseSetbackFactor = try! LapseSetbackFactor.makeFromFloat(modifier: 0.5)
    private (set) var minimumInterval: MinimumInterval = MinimumInterval.makeFromTimeInterval(intervalSeconds: 86400) //  1d
    
    private (set) var easeFactor: EaseFactor = try! EaseFactor.makeFromFloat(easeFactor: 2.0)
    private (set) var easyFactorModifier: EasyFactorModifier = try! EasyFactorModifier.makeFromFloat(modifier: 0.15)
    private (set) var normalFactorModifier: NormalFactorModifier = try! NormalFactorModifier.makeFromFloat(modifier: 0.05)
    private (set) var hardFactorModifier: HardFactorModifier = try! HardFactorModifier.makeFromFloat(modifier: -0.1)
    private (set) var lapseFactorModifier: LapseFactorModifier = try! LapseFactorModifier.makeFromFloat(modifier: -0.2)
    
    private (set) var easyIntervalModifier: EasyIntervalModifier = try! EasyIntervalModifier.makeFromFloat(modifier: 1.2)

    
    var isDefaultPreset: Bool {
        get {
            name == SchedulePreset.defaultPresetName
        }
    }
    
    
    static func makeDefaultPreset() -> SchedulePreset {
        return SchedulePreset(defaultName: defaultPresetName)
    }
    
    private init(defaultName: String) {
        self.name = defaultName
    }
    
    init(name: String) throws {
        try SchedulePreset.validateNameNotDefault(name: name)
        self.name = name
    }
    
    init(name: String, learningSteps: LearningSteps, graduationInterval: GraduationInterval, lapseSteps: LapseSteps, lapseSetbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval, easeFactor: EaseFactor, easyFactorModifier: EasyFactorModifier, normalFactorModifier: NormalFactorModifier, hardFactorModifier: HardFactorModifier, lapseFactorModifier: LapseFactorModifier, easyIntervalModifier: EasyIntervalModifier) throws {
        try SchedulePreset.validateNameNotDefault(name: name)
        self.name = name
        self.learningSteps = learningSteps
        self.graduationInterval = graduationInterval
        self.lapseSteps = lapseSteps
        self.lapseSetbackFactor = lapseSetbackFactor
        self.minimumInterval = minimumInterval
        self.easeFactor = easeFactor
        self.easyFactorModifier = easyFactorModifier
        self.normalFactorModifier = normalFactorModifier
        self.hardFactorModifier = hardFactorModifier
        self.lapseFactorModifier = lapseFactorModifier
        self.easyIntervalModifier = easyIntervalModifier
    }
    
    init(schedulePreset: SchedulePreset, name: String, learningSteps: LearningSteps, graduationInterval: GraduationInterval, lapseSteps: LapseSteps, lapseSetbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval, easeFactor: EaseFactor, easyFactorModifier: EasyFactorModifier, normalFactorModifier: NormalFactorModifier, hardFactorModifier: HardFactorModifier, lapseFactorModifier: LapseFactorModifier, easyIntervalModifier: EasyIntervalModifier) throws {
        try SchedulePreset.validateImmutableDefaultPreset(preset: schedulePreset)
        self = schedulePreset
        self.name = name
        self.learningSteps = learningSteps
        self.graduationInterval = graduationInterval
        self.lapseSteps = lapseSteps
        self.lapseSetbackFactor = lapseSetbackFactor
        self.minimumInterval = minimumInterval
        self.easeFactor = easeFactor
        self.easyFactorModifier = easyFactorModifier
        self.normalFactorModifier = normalFactorModifier
        self.hardFactorModifier = hardFactorModifier
        self.lapseFactorModifier = lapseFactorModifier
        self.easyIntervalModifier = easyIntervalModifier
    }
    

    
    func getNextLearningStep(learningIndex: Int) -> TimeInterval? {
        if learningIndex < learningSteps.learningStepsSeconds.count {
            return learningSteps.learningStepsSeconds[learningIndex]
        } else if learningIndex == learningSteps.learningStepsSeconds.count {
            return graduationInterval.intervalSeconds
        } else {
            return nil
        }
    }

    func getNextLapseStep(lapseIndex: Int) -> TimeInterval? {
        lapseIndex < lapseSteps.lapseStepsSeconds.count ? lapseSteps.lapseStepsSeconds[lapseIndex] : nil
    }

    mutating func rename(name: String) throws {
        try SchedulePreset.validateNameNotDefault(name: name)
        self.name = name
    }

    mutating func setLapseSteps(steps: LapseSteps) throws {
        try SchedulePreset.validateImmutableDefaultPreset(preset: self)
        self.lapseSteps = steps
    }

    @discardableResult
    private static func validateNameNotDefault(name: String) throws -> Bool {
        guard name != SchedulePreset.defaultPresetName else {
            throw SchedulePresetException.NameConflictsDefaultName
        }
        return true
    }
    
    @discardableResult
    private static func validateImmutableDefaultPreset(preset: SchedulePreset) throws -> Bool {
        guard !preset.isDefaultPreset else {
            throw SchedulePresetException.DefaultPresetIsImmutable
        }
        return true
    }
}

extension SchedulePreset: Equatable {
    static func == (lhs: SchedulePreset, rhs: SchedulePreset) -> Bool {
        return
            lhs.id == rhs.id
    }
}
