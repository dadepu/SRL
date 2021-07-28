//
//  Interval.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct ReviewInterval: Codable {
    private (set) var intervalSeconds: TimeInterval
    
    private init(intervalSeconds: TimeInterval) {
        self.intervalSeconds = intervalSeconds
    }
    
    static func makeFromTimeInterval(intervalSeconds: TimeInterval) -> ReviewInterval {
        return ReviewInterval(intervalSeconds: intervalSeconds)
    }
    
    func nextReviewInterval(easeFactor: EaseFactor, intervalModifier: IntervalModifier? = nil, minimumInterval: MinimumInterval? = nil) -> ReviewInterval {
        let intervalModifierCorrected = intervalModifier != nil ? Double(intervalModifier!.intervalModifier) : 1.0
        let newInterval = round(Double(self.intervalSeconds) * Double(easeFactor.easeFactor) * Double(intervalModifierCorrected))
        
        guard minimumInterval == nil else {
            let appliedMinimumInterval = minimumInterval!.intervalSeconds <= newInterval ? newInterval : minimumInterval!.intervalSeconds
            return ReviewInterval(intervalSeconds: appliedMinimumInterval)
        }
        return ReviewInterval(intervalSeconds: newInterval)
    }
    
    func lapseInterval(setbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval? = nil) -> ReviewInterval {
        let newInterval = round(Double(self.intervalSeconds) * Double(setbackFactor.remainingInterval))
        guard minimumInterval == nil else {
            let minimumAppliedInterval = newInterval < minimumInterval!.intervalSeconds ? minimumInterval!.intervalSeconds : newInterval
            return ReviewInterval(intervalSeconds: minimumAppliedInterval)
        }
        return ReviewInterval(intervalSeconds: newInterval)
    }
}
