//
//  SchedulePreset.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct SchedulePreset: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var name: String
    
    private (set) var learningSteps: Array<TimeInterval> = [64800, 496800, 1274400]         // 1d, 6d, 15d
    private (set) var lapseSteps: Array<TimeInterval> = [64800, 496800]                     // 1d, 6d
    private (set) var graduationInterval: TimeInterval = 2592000                            // 30d
    private (set) var matureInterval: TimeInterval = 2419200
    
    private (set) var lapseSetBackFactor: Float = 0.5
    private (set) var easeFactor: Float = 2.0
    private (set) var easyFactorModifier: Float = 0.15
    private (set) var normalFactorModifier: Float = 0.05
    private (set) var hardFactorModifier: Float = -0.1
    private (set) var lapseFactorModifier: Float = -0.2
    private (set) var easyIntervalModifier: Float = 1.2
    private (set) var minimumInterval: TimeInterval = 86400         //  1d
    
    var isDefaultPreset: Bool {
        get {
            name == "Default"
        }
    }
    
    
    init(name: String) {
        self.name = name
    }
    
    
    
    func getNextLearningStep(learningIndex: Int) -> TimeInterval? {
        if learningIndex < learningSteps.count {
            return learningSteps[learningIndex]
        } else if learningIndex == learningSteps.count {
            return graduationInterval
        } else {
            return nil
        }
    }
    
    func getNextLapseStep(lapseIndex: Int) -> TimeInterval? {
        lapseIndex < lapseSteps.count ? lapseSteps[lapseIndex] : nil
    }
    
    mutating func rename(name: String) throws {
        try validateOrThrowIsNotDefaultPreset()
        self.name = name
    }
    
    mutating func setLapseSteps(steps: Array<TimeInterval>) throws {
        try validateOrThrowIsNotDefaultPreset()
        lapseSteps = steps
    }
    
    private func validateOrThrowIsNotDefaultPreset() throws {
        if isDefaultPreset {
            throw SchedulePresetException.defaultPresetIsImmutable
        }
    }
}

extension SchedulePreset: Equatable {
    static func == (lhs: SchedulePreset, rhs: SchedulePreset) -> Bool {
        return
            lhs.id == rhs.id
    }
}
