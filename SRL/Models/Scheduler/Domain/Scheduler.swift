//
//  Scheduler.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Scheduler: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var schedulePreset: SchedulePreset
    
    private (set) var learningState: LearningState = LearningState.LEARNING
    private (set) var lastReviewDate: Date = Date()
    private (set) var nextReviewDate: Date = Date()
    private (set) var currentReviewInterval: TimeInterval = 0
    private (set) var reviewCount: Int = 0
    private (set) var easeFactor: Float
    
    private       var learningStepIndex: Int = 0
    private       var lapseStepIndex: Int = 0
    private       var lapseLastReviewInterval: TimeInterval = 0
    
    
    var remainingReviewInterval: TimeInterval {
        get {
            if nextReviewDate > Date() {
                return DateInterval(start: Date(), end: nextReviewDate).duration
            } else {
                return DateInterval(start: nextReviewDate, end: Date()).duration * -1
            }
        }
    }
    var isDueForReview: Bool {
        get {
            remainingReviewInterval <= 0
        }
    }
    var cardIsNew: Bool {
        get {
            reviewCount == 0
        }
    }
    
    
    
    init(schedulePreset: SchedulePreset) {
        self.schedulePreset = schedulePreset
        self.easeFactor = schedulePreset.easeFactor
        initializeCardSchedule(schedulePreset: schedulePreset)
    }
    
    private mutating func initializeCardSchedule(schedulePreset: SchedulePreset) {
//        let interval = schedulePreset.getNextLearningStep(learningIndex: 0) ?? schedulePreset.minimumInterval
//        self = setNextReviewDate(for: self, with: interval)
//        learningStepIndex = 1
        let interval = 0.0
        self = setNextReviewDate(for: self, with: interval)
        learningStepIndex = 0
        easeFactor = schedulePreset.easeFactor
    }
    
    /**
        UNIT TESTING PURPOSE ONLY
     */
    init(schedulePreset: SchedulePreset, easeFactor: Float, learningState: LearningState, lastReviewDate: Date,
         nextReviewDate: Date, cardStudyCount: Int, learningStepIndex: Int, lapseStepIndex: Int,
         currentReviewInterval: TimeInterval)
    {
        self.schedulePreset = schedulePreset
        self.easeFactor = easeFactor
        self.learningState = learningState
        self.lastReviewDate = lastReviewDate
        self.nextReviewDate = nextReviewDate
        self.reviewCount = cardStudyCount
        self.learningStepIndex = learningStepIndex
        self.lapseStepIndex = lapseStepIndex
        self.currentReviewInterval = currentReviewInterval
    }
    

    
    func processedReviewAction(as action: ReviewAction) -> Scheduler {
        var scheduler = self
        
        switch (action, learningState) {
        case (.GOOD, .LEARNING):
            scheduler = handledReviewActionGoodLearning(scheduler)
        case (.GOOD, .REVIEW):
            scheduler = handledReviewActionGoodReview(scheduler)
        case (.GOOD, .LAPSE):
            scheduler = handledReviewActionGoodLapse(scheduler)
        case (.REPEAT, .LEARNING):
            scheduler = handledReviewActionRepeatLearning(scheduler)
        case (.REPEAT, .REVIEW), (.REPEAT, .LAPSE):
            scheduler = handledReviewActionRepeatReviewLapse(scheduler)
        case (.EASY, .LEARNING):
            scheduler = handledReviewActionEasyLearning(scheduler)
        case (.EASY, .REVIEW):
            scheduler = handledReviewActionEasyReview(scheduler)
        case (.EASY, .LAPSE):
            scheduler = handledReviewActionEasyLapse(scheduler)
        case (.HARD, .LEARNING):
            scheduler = handledReviewActionHardLearning(scheduler)
        case (.HARD, .REVIEW), (.HARD, .LAPSE):
            scheduler = handledReviewActionHardReviewLapse(scheduler)
        case (.CUSTOMINTERVAL(let interval), _):
            scheduler = handledReviewActionCustomIntervalAllStates(for: interval)
        }
        return incrementReviewCount(for: scheduler, by: 1)
    }
    
    private func handledReviewActionGoodLearning(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        if let nextStepInterval = scheduler.schedulePreset.getNextLearningStep(learningIndex: scheduler.learningStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: nextStepInterval)
        } else {
            let newInterval = scheduler.calculateInterval(
                    baseInterval: scheduler.currentReviewInterval,
                    factor: scheduler.easeFactor,
                    considerMinimumInterval: true,
                    minimumInterval: scheduler.schedulePreset.minimumInterval
            )
            scheduler = setNextReviewDate(for: scheduler, with: newInterval)
            scheduler.learningState = LearningState.REVIEW
        }
        scheduler.learningStepIndex += 1
        return scheduler
    }
    
    private func handledReviewActionGoodReview(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        let easeFactor = scheduler.calculateModifiedFactor(
                for: scheduler.easeFactor,
                with: scheduler.schedulePreset.normalFactorModifier
        )
        let newInterval = scheduler.calculateInterval(
                baseInterval: scheduler.currentReviewInterval,
                factor: easeFactor,
                considerMinimumInterval: true,
                minimumInterval: scheduler.schedulePreset.minimumInterval
        )
        scheduler.easeFactor = easeFactor
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionGoodLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        if let nextStepInterval = scheduler.schedulePreset.getNextLapseStep(lapseIndex: scheduler.lapseStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: nextStepInterval)
        } else {
            scheduler = setNextReviewDate(for: scheduler, with: lapseLastReviewInterval)
            scheduler.learningState = LearningState.REVIEW
        }
        scheduler.lapseStepIndex += 1
        return scheduler
    }
    
    private func handledReviewActionRepeatLearning(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        let newInterval: TimeInterval = scheduler.schedulePreset.getNextLearningStep(learningIndex: 0)!
        scheduler.learningStepIndex = 1
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        return scheduler
    }
    
    private func handledReviewActionRepeatReviewLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.lapseStepIndex = 0
        scheduler.easeFactor = calculateModifiedFactor(
            for: scheduler.easeFactor,
            with: scheduler.schedulePreset.lapseFactorModifier
        )
        let previousReviewInterval = scheduler.learningState == .REVIEW ? scheduler.currentReviewInterval : scheduler.lapseLastReviewInterval
        scheduler.lapseLastReviewInterval = calculateInterval(
            baseInterval: previousReviewInterval,
            intervalModifier: scheduler.schedulePreset.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.schedulePreset.minimumInterval
        )
        if let newInterval = scheduler.schedulePreset.getNextLapseStep(lapseIndex: scheduler.lapseStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: newInterval)
            scheduler.learningState = LearningState.LAPSE
        } else {
            scheduler = setNextReviewDate(for: scheduler, with: scheduler.lapseLastReviewInterval)
            scheduler.learningState = LearningState.REVIEW
        }
        scheduler.lapseStepIndex += 1
        return scheduler
    }
    
    private func handledReviewActionEasyLearning(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        if let _ = scheduler.schedulePreset.getNextLearningStep(learningIndex: scheduler.learningStepIndex) {
            scheduler = setNextReviewDate(
                for: scheduler,
                with: scheduler.schedulePreset.graduationInterval
            )
        } else {
            scheduler.easeFactor = calculateModifiedFactor(
                for: scheduler.easeFactor,
                with: scheduler.schedulePreset.easyFactorModifier
            )
            let newInterval = calculateInterval(
                baseInterval: scheduler.currentReviewInterval,
                factor: scheduler.easeFactor,
                intervalModifier: scheduler.schedulePreset.easyIntervalModifier,
                considerMinimumInterval: true,
                minimumInterval: scheduler.schedulePreset.minimumInterval
            )
            scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        }
        scheduler.learningStepIndex += 1
        scheduler.learningState = LearningState.REVIEW
        return scheduler
    }
    
    private func handledReviewActionEasyReview(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.easeFactor = calculateModifiedFactor(
            for: scheduler.easeFactor,
            with: scheduler.schedulePreset.easyFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.easeFactor,
            intervalModifier: scheduler.schedulePreset.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: scheduler.schedulePreset.minimumInterval
        )
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        return scheduler
    }
    
    private func handledReviewActionEasyLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.easeFactor = calculateModifiedFactor(
            for: scheduler.easeFactor,
            with: scheduler.schedulePreset.easyFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: scheduler.lapseLastReviewInterval,
            intervalModifier: scheduler.schedulePreset.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: scheduler.schedulePreset.minimumInterval
        )
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        scheduler.learningState = LearningState.REVIEW
        return scheduler
    }
    
    private func handledReviewActionHardLearning(_ scheduler: Scheduler) -> Scheduler {
        let newInterval = currentReviewInterval
        return setNextReviewDate(for: self, with: newInterval)
    }
    
    private func handledReviewActionHardReviewLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = self
        scheduler.easeFactor = calculateModifiedFactor(
            for: scheduler.easeFactor,
            with: scheduler.schedulePreset.hardFactorModifier
        )
        let newInterval = currentReviewInterval
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionCustomIntervalAllStates(for interval: TimeInterval) -> Scheduler{
        var scheduler = self
        scheduler = setNextReviewDate(for: scheduler, with: interval)
        scheduler.learningState = LearningState.REVIEW
        return scheduler
    }
    
    private func setNextReviewDate(for previousScheduler : Scheduler, with interval: TimeInterval) -> Scheduler {
        var scheduler = previousScheduler
        scheduler.currentReviewInterval = interval
        scheduler.lastReviewDate = Date()
        scheduler.nextReviewDate = DateInterval(start: Date(), duration: interval).end
        return scheduler
    }
    
    private func incrementReviewCount(for previousScheduler: Scheduler, by: Int) -> Scheduler {
        var scheduler = previousScheduler
        scheduler.reviewCount += by
        return scheduler
    }
    
    
    
    func calculateModifiedFactor(for baseFactor: Float, with modifier: Float) -> Float {
        ((baseFactor + modifier) * 100).rounded() / 100
    }
    
    func calculateInterval(baseInterval: TimeInterval, factor: Float = 1.0, intervalModifier: Float = 1.0,
                           considerMinimumInterval: Bool = false, minimumInterval: TimeInterval = 0 ) -> TimeInterval
    {
        let newInterval = round(Double(baseInterval) * Double(factor) * Double(intervalModifier))
        return newInterval < minimumInterval && considerMinimumInterval ? minimumInterval : newInterval
    }
    
    
    
    func hasSetSchedulePreset(_ preset: SchedulePreset) -> Scheduler {
        var scheduler = self
        scheduler.schedulePreset = preset
        return scheduler
    }
}
