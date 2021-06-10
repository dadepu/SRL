//
//  Scheduler.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Scheduler: Schedulable, Codable {
    var settings: SchedulerSettings
    private (set) var learningState: LearningState = LearningState.LEARNING
    private (set) var lastReviewDate: Date = Date()
    private (set) var nextReviewDate: Date = Date()
    private (set) var currentReviewInterval: TimeInterval = 0
    private (set) var reviewCount: Int = 0
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
    
    
    
    init() {
        settings = SchedulerSettings()
        initializeCardSchedule()
    }

    init(settings: SchedulerSettings, cardCreated: Date) {
        self.settings = settings
        self.lastReviewDate = cardCreated
        initializeCardSchedule()
    }
    
    // for testing purpose only
    init(settings: SchedulerSettings, learningState: LearningState, lastReviewDate: Date, nextReviewDate: Date,
         cardStudyCount: Int, learningStepIndex: Int, lapseStepIndex: Int, currentReviewInterval: TimeInterval)
    {
        self.settings = settings
        self.learningState = learningState
        self.lastReviewDate = lastReviewDate
        self.nextReviewDate = nextReviewDate
        self.reviewCount = cardStudyCount
        self.learningStepIndex = learningStepIndex
        self.lapseStepIndex = lapseStepIndex
        self.currentReviewInterval = currentReviewInterval
    }
    
    private mutating func initializeCardSchedule() {
        let interval = settings.getNextLearningStep(learningIndex: 0) ?? settings.minimumInterval
        self = setNextReviewDate(for: self, with: interval)
        learningStepIndex = 1
    }
    
    
    
    func processedReviewAction(as action: ReviewAction) -> Scheduler {
        var scheduler = self
        switch (action, learningState) {
        case (.GOOD, .LEARNING):
            scheduler = handledReviewActionGoodLearning()
        case (.GOOD, .REVIEW):
            scheduler = handledReviewActionGoodReview()
        case (.GOOD, .LAPSE):
            scheduler = handledReviewActionGoodLapse()
        case (.REPEAT, .LEARNING):
            scheduler = handledReviewActionRepeatLearning()
        case (.REPEAT, .REVIEW), (.REPEAT, .LAPSE):
            scheduler = handledReviewActionRepeatReviewLapse()
        case (.EASY, .LEARNING):
            scheduler = handledReviewActionEasyLearning()
        case (.EASY, .REVIEW):
            scheduler = handledReviewActionEasyReview()
        case (.EASY, .LAPSE):
            scheduler = handledReviewActionEasyLapse()
        case (.HARD, .LEARNING):
            scheduler = handledReviewActionHardLearning()
        case (.HARD, .REVIEW), (.HARD, .LAPSE):
            scheduler = handledReviewActionHardReviewLapse()
        case (.CUSTOMINTERVAL(let interval), _):
            scheduler = handledReviewActionCustomIntervalAllStates(for: interval)
        }
        return incrementReviewCount(for: scheduler, by: 1)
    }
    
    private func handledReviewActionGoodLearning() -> Scheduler {
        var scheduler = self
        if let nextStepInterval = scheduler.settings.getNextLearningStep(learningIndex: scheduler.learningStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: nextStepInterval)
        } else {
            let newInterval = scheduler.calculateInterval(
                baseInterval: scheduler.currentReviewInterval,
                factor: scheduler.settings.easeFactor,
                considerMinimumInterval: true,
                minimumInterval: scheduler.settings.minimumInterval
            )
            scheduler = setNextReviewDate(for: scheduler, with: newInterval)
            scheduler.learningState = LearningState.REVIEW
        }
        scheduler.learningStepIndex += 1
        return scheduler
    }
    
    private func handledReviewActionGoodReview() -> Scheduler {
        var scheduler = self
        scheduler.settings.easeFactor = scheduler.calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.normalFactorModifier
        )
        let newInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.settings.easeFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionGoodLapse() -> Scheduler {
        var scheduler = self
        if let nextStepInterval = scheduler.settings.getNextLapseStep(lapseIndex: scheduler.lapseStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: nextStepInterval)
        } else {
            scheduler = setNextReviewDate(for: scheduler, with: lapseLastReviewInterval)
            scheduler.learningState = LearningState.REVIEW
        }
        scheduler.lapseStepIndex += 1
        return scheduler
    }
    
    private func handledReviewActionRepeatLearning() -> Scheduler {
        var scheduler = self
        let newInterval: TimeInterval = scheduler.settings.getNextLearningStep(learningIndex: 0)!
        scheduler.learningStepIndex = 1
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        return scheduler
    }
    
    private func handledReviewActionRepeatReviewLapse() -> Scheduler {
        var scheduler = self
        scheduler.lapseStepIndex = 0
        scheduler.settings.easeFactor = calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.lapseFactorModifier
        )
        let previousReviewInterval = scheduler.learningState == .REVIEW ? scheduler.currentReviewInterval : scheduler.lapseLastReviewInterval
        scheduler.lapseLastReviewInterval = calculateInterval(
            baseInterval: previousReviewInterval,
            intervalModifier: scheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        if let newInterval = scheduler.settings.getNextLapseStep(lapseIndex: scheduler.lapseStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: newInterval)
            scheduler.learningState = LearningState.LAPSE
        } else {
            scheduler = setNextReviewDate(for: scheduler, with: scheduler.lapseLastReviewInterval)
            scheduler.learningState = LearningState.REVIEW
        }
        scheduler.lapseStepIndex += 1
        return scheduler
    }
    
    private func handledReviewActionEasyLearning() -> Scheduler {
        var scheduler = self
        if let _ = scheduler.settings.getNextLearningStep(learningIndex: scheduler.learningStepIndex) {
            scheduler = setNextReviewDate(for: scheduler, with: scheduler.settings.graduationInterval)
        } else {
            scheduler.settings.easeFactor = calculateModifiedFactor(
                for: scheduler.settings.easeFactor,
                with: scheduler.settings.easyFactorModifier
            )
            let newInterval = calculateInterval(
                baseInterval: scheduler.currentReviewInterval,
                factor: scheduler.settings.easeFactor,
                intervalModifier: scheduler.settings.easyIntervalModifier,
                considerMinimumInterval: true,
                minimumInterval: scheduler.settings.minimumInterval
            )
            scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        }
        scheduler.learningStepIndex += 1
        scheduler.learningState = LearningState.REVIEW
        return scheduler
    }
    
    private func handledReviewActionEasyReview() -> Scheduler {
        var scheduler = self
        scheduler.settings.easeFactor = calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.easyFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.settings.easeFactor,
            intervalModifier: scheduler.settings.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        return scheduler
    }
    
    private func handledReviewActionEasyLapse() -> Scheduler {
        var scheduler = self
        scheduler.settings.easeFactor = calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.easyFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: scheduler.lapseLastReviewInterval,
            intervalModifier: scheduler.settings.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        scheduler.learningState = LearningState.REVIEW
        return scheduler
    }
    
    private func handledReviewActionHardLearning() -> Scheduler {
        let newInterval = currentReviewInterval
        return setNextReviewDate(for: self, with: newInterval)
    }
    
    private func handledReviewActionHardReviewLapse() -> Scheduler {
        var scheduler = self
        scheduler.settings.easeFactor = calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.hardFactorModifier
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
}
