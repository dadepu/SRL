//
//  SchedulerSettings.swift
//  SRL
//
//  Created by Daniel Koellgen on 27.05.21.
//

import Foundation

struct SchedulerSettings: Codable{
    var learningSteps: Array<TimeInterval>          = [64800, 496800, 1274400]          // 1d, 6d, 15d
    var lapseSteps: Array<TimeInterval>             = [64800, 496800]                   // 1d, 6d
    var graduationInterval: TimeInterval            = 2592000                           // 30d
    private (set) var matureInterval: TimeInterval  = 2419200
    
    var lapseSetBackFactor: Float       = 0.5
    var easeFactor: Float               = 2.0
    var easyFactorModifier: Float       = 0.15
    var normalFactorModifier: Float     = 0.05
    var hardFactorModifier: Float       = -0.1
    var lapseFactorModifier: Float      = -0.2
    
    var easyIntervalModifier: Float     = 1.2
    
    var minimumInterval: TimeInterval   = 86400            //  1d
    
    
    
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
}
