//
//  LapseStep.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct LapseStep: Codable {
    private (set) var lapseIndex: Int = 0
    private (set) var previousReviewInterval: ReviewInterval
    private (set) var previousReviewIntervalSetbackIncluded: ReviewInterval
    
    
    private init(lapseIndex: Int, previousInterval: ReviewInterval, previousIntervalSetback: ReviewInterval) {
        self.lapseIndex = lapseIndex
        self.previousReviewInterval = previousInterval
        self.previousReviewIntervalSetbackIncluded = previousIntervalSetback
    }
    
    static func makeNew(previousInterval: ReviewInterval, setbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval? = nil) -> LapseStep {
        let setbackInterval = previousInterval.lapseInterval(setbackFactor: setbackFactor, minimumInterval: minimumInterval)
        return LapseStep(lapseIndex: 0, previousInterval: previousInterval, previousIntervalSetback: setbackInterval)
    }
    
    static func makeNewFromPreviousStep(_ lapseStep: LapseStep, setbackFactor: LapseSetbackFactor, minimumInterval: MinimumInterval? = nil) -> LapseStep {
        let setbackInterval = lapseStep.previousReviewIntervalSetbackIncluded.lapseInterval(setbackFactor: setbackFactor, minimumInterval: minimumInterval)
        return LapseStep(lapseIndex: 0, previousInterval: lapseStep.previousReviewIntervalSetbackIncluded, previousIntervalSetback: setbackInterval)
    }
    
    func incrementedStep() -> LapseStep {
        var updatedStep = self
        updatedStep.lapseIndex += 1
        return updatedStep
    }
}
