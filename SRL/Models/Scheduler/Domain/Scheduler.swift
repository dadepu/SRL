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
    private (set) var lastReviewDate: ReviewDate = ReviewDate.makeFromCurrentDate()
    private (set) var nextReviewDate: ReviewDate = ReviewDate.makeFromCurrentDate()
    private (set) var currentReviewInterval: ReviewInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: 0)
    private (set) var reviewCount: Int = 0
    private (set) var easeFactor: EaseFactor
    
    private (set) var learningStep: LearningStep = LearningStep.makeNew()
    private (set) var lapseStep: LapseStep?
    
    
    var remainingReviewInterval: TimeInterval {
        get {
            guard nextReviewDate.date > Date() else {
                return DateInterval(start: nextReviewDate.date, end: Date()).duration * -1
            }
            return DateInterval(start: Date(), end: nextReviewDate.date).duration
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
    var isGraduateable: Bool {
        get {
            learningState == .LEARNING
        }
    }
    
    
    
    init(schedulePreset: SchedulePreset) {
        self.schedulePreset = schedulePreset
        self.easeFactor = schedulePreset.easeFactor
    }
    
    /**
        UNIT TESTING PURPOSE ONLY
     */
    init(schedulePreset: SchedulePreset, easeFactor: EaseFactor, learningState: LearningState, lastReviewDate: ReviewDate,
         nextReviewDate: ReviewDate, cardStudyCount: Int, learningStep: LearningStep, lapseStep: LapseStep?, currentReviewInterval: ReviewInterval) {
        self.schedulePreset = schedulePreset
        self.easeFactor = easeFactor
        self.learningState = learningState
        self.lastReviewDate = lastReviewDate
        self.nextReviewDate = nextReviewDate
        self.reviewCount = cardStudyCount
        self.learningStep = learningStep
        self.lapseStep = lapseStep
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
        case (.REPEAT, .REVIEW):
            scheduler = handledReviewActionRepeatReview(scheduler)
        case (.REPEAT, .LAPSE):
            scheduler = handledReviewActionRepeatLapse(scheduler)
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
        scheduler.reviewCount += 1
        return scheduler
    }
    
    private func setNextReviewDate(for previousScheduler : Scheduler, with interval: ReviewInterval) -> Scheduler {
        var scheduler = previousScheduler
        scheduler.currentReviewInterval = interval
        scheduler.lastReviewDate = ReviewDate.makeFromCurrentDate()
        scheduler.nextReviewDate = ReviewDate.makeFromInterval(interval: interval)
        return scheduler
    }
    

    
    
    
    private func handledReviewActionEasyLearning(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.learningState = LearningState.REVIEW
        guard let _ = scheduler.schedulePreset.getNextLearningStep(learningIndex: scheduler.learningStep.learningIndex) else {
            scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.easyFactorModifier)
            let newInterval = scheduler.currentReviewInterval.nextReviewInterval(easeFactor: scheduler.easeFactor, intervalModifier: scheduler.schedulePreset.easyIntervalModifier, minimumInterval: scheduler.schedulePreset.minimumInterval)
            return setNextReviewDate(for: scheduler, with: newInterval)
        }
        let graduationInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: scheduler.schedulePreset.graduationInterval.intervalSeconds)
        return setNextReviewDate(for: scheduler, with: graduationInterval)
    }
    
    private func handledReviewActionGoodLearning(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.learningStep = scheduler.learningStep.incrementedStep()
        guard let nextStepSeconds = scheduler.schedulePreset.getNextLearningStep(learningIndex: scheduler.learningStep.learningIndex) else {
            scheduler.learningState = LearningState.REVIEW
            let newGraduatedInterval = scheduler.currentReviewInterval.nextReviewInterval(easeFactor: scheduler.easeFactor)
            return setNextReviewDate(for: scheduler, with: newGraduatedInterval)
        }
        let nextStepInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: nextStepSeconds)
        return setNextReviewDate(for: scheduler, with: nextStepInterval)
    }
    
    private func handledReviewActionHardLearning(_ scheduler: Scheduler) -> Scheduler {      
        scheduler.setNextReviewDate(for: scheduler, with: scheduler.currentReviewInterval)
    }
    
    private func handledReviewActionRepeatLearning(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.learningStep = LearningStep.makeNew()
        let newInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: scheduler.schedulePreset.getNextLearningStep(learningIndex: 0)!)
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionEasyReview(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.easyFactorModifier)
        let newInterval = scheduler.currentReviewInterval.nextReviewInterval(easeFactor: scheduler.easeFactor, intervalModifier: scheduler.schedulePreset.easyIntervalModifier, minimumInterval: scheduler.schedulePreset.minimumInterval)
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionGoodReview(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.normalFactorModifier)
        let newInterval = scheduler.currentReviewInterval.nextReviewInterval(easeFactor: scheduler.easeFactor, minimumInterval: scheduler.schedulePreset.minimumInterval)
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionHardReviewLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = self
        scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.hardFactorModifier)
        let newInterval = scheduler.currentReviewInterval
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionRepeatReview(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = self
        scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.lapseFactorModifier)
        scheduler.lapseStep = LapseStep.makeNew(previousInterval: scheduler.currentReviewInterval, setbackFactor: scheduler.schedulePreset.lapseSetbackFactor, minimumInterval: scheduler.schedulePreset.minimumInterval)
        guard let lapseStepSeconds = scheduler.schedulePreset.getNextLapseStep(lapseIndex: scheduler.lapseStep!.lapseIndex) else {
            let newInterval = scheduler.lapseStep!.previousReviewIntervalSetbackIncluded
            return setNextReviewDate(for: scheduler, with: newInterval)
        }
        scheduler.learningState = .LAPSE
        let newStepInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: lapseStepSeconds)
        return setNextReviewDate(for: scheduler, with: newStepInterval)
    }
    
    private func handledReviewActionRepeatLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.lapseFactorModifier)
        scheduler.lapseStep = LapseStep.makeNewFromPreviousStep(scheduler.lapseStep!, setbackFactor: scheduler.schedulePreset.lapseSetbackFactor, minimumInterval: scheduler.schedulePreset.minimumInterval)
        guard let lapseStepSeconds = scheduler.schedulePreset.getNextLapseStep(lapseIndex: scheduler.lapseStep!.lapseIndex) else {
            let newInterval = scheduler.lapseStep!.previousReviewIntervalSetbackIncluded
            return setNextReviewDate(for: scheduler, with: newInterval)
        }
        let newStepInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: lapseStepSeconds)
        return setNextReviewDate(for: scheduler, with: newStepInterval)
    }
    
    private func handledReviewActionEasyLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.learningState = LearningState.REVIEW
        scheduler.easeFactor = scheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler.schedulePreset.easyFactorModifier)
        guard let lapseStep = scheduler.lapseStep else {
            // error case that should not exist
            let minimumInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: scheduler.schedulePreset.minimumInterval.intervalSeconds)
            return setNextReviewDate(for: scheduler, with: minimumInterval)
        }
        let newInterval = lapseStep.previousReviewIntervalSetbackIncluded.nextReviewInterval(easeFactor: scheduler.easeFactor, intervalModifier: scheduler.schedulePreset.easyIntervalModifier, minimumInterval: scheduler.schedulePreset.minimumInterval)
        return setNextReviewDate(for: scheduler, with: newInterval)
    }
    
    private func handledReviewActionGoodLapse(_ scheduler: Scheduler) -> Scheduler {
        var scheduler = scheduler
        scheduler.lapseStep = scheduler.lapseStep!.incrementedStep()
        guard let nextStepSeconds = scheduler.schedulePreset.getNextLapseStep(lapseIndex: scheduler.lapseStep!.lapseIndex) else {
            scheduler.learningState = LearningState.REVIEW
            let newReviewInterval = scheduler.lapseStep!.previousReviewIntervalSetbackIncluded
            return setNextReviewDate(for: scheduler, with: newReviewInterval)
        }
        let nextLapseInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: nextStepSeconds)
        return setNextReviewDate(for: scheduler, with: nextLapseInterval)
    }
    
    private func handledReviewActionCustomIntervalAllStates(for interval: TimeInterval) -> Scheduler{
        var scheduler = self
        let newInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: interval)
        scheduler = setNextReviewDate(for: scheduler, with: newInterval)
        scheduler.learningState = LearningState.REVIEW
        return scheduler
    }
    
    

    
    mutating func setSchedulePreset(_ updatedPreset: SchedulePreset) {
        self.schedulePreset = updatedPreset
    }
    
    mutating func replaceEaseFactor(_ updatedFactor: EaseFactor) {
        self.easeFactor = updatedFactor
    }
    
    func resettedScheduler() -> Scheduler {
        var newScheduler = Scheduler(schedulePreset: self.schedulePreset)
        newScheduler.id = self.id
        newScheduler.reviewCount = self.reviewCount
        return newScheduler
    }
    
    func graduatedScheduler() throws -> Scheduler {
        guard self.learningState == .LEARNING else {
            throw SchedulerException.LearningstateNotPermittingGraduation
        }
        return handledReviewActionEasyLearning(self)
    }
}
