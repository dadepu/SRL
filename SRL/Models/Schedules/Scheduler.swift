//
//  Schedule.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//        let formatter = DateFormatter()
//        formatter.timeZone = .current
//        formatter.locale = .current
//        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
//
//        let currentDate: Date = Date()
//        let interval: TimeInterval = 60*1.8
//        let dateInterval: DateInterval = DateInterval(start: currentDate, duration: interval)
//        let endDate: Date = dateInterval.end
//
//        print("StartDate: \(formatter.string(from: currentDate))")
//        print("EndDate: \(formatter.string(from: endDate))")

import Foundation

struct Scheduler: Schedulable {
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
    
    //test purpose only
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
    
    
    
    mutating func processReviewAction(action: ReviewAction) {
        switch (action, learningState) {
        case (.GOOD, .LEARNING):
            handleReviewActionGoodLearning()
        case (.GOOD, .REVIEW):
            handleReviewActionGoodReview()
        case (.GOOD, .LAPSE):
            handleReviewActionGoodLapse()
        case (.REPEAT, .LEARNING):
            handleReviewActionRepeatLearning()
        case (.REPEAT, .REVIEW), (.REPEAT, .LAPSE):
            handleReviewActionRepeatReviewLapse()
        case (.EASY, .LEARNING):
            handleReviewActionEasyLearning()
        case (.EASY, .REVIEW):
            handleReviewActionEasyReview()
        case (.EASY, .LAPSE):
            handleReviewActionEasyLapse()
        case (.HARD, .LEARNING):
            handleReviewActionHardLearning()
        case (.HARD, .REVIEW), (.HARD, .LAPSE):
            handleReviewActionHardReviewLapse()
        case (.CUSTOMINTERVAL(let interval), _):
            handleReviewActionCustomIntervalAllStates(customInterval: interval)
        }
        incrementReviewCount()
    }
    
    private mutating func handleReviewActionGoodLearning() {
        if let nextStepInterval = settings.getNextLearningStep(learningIndex: learningStepIndex) {
            setNextReviewDate(interval: nextStepInterval)
        } else {
            let newInterval = calculateInterval(
                baseInterval: currentReviewInterval,
                factor: settings.easeFactor,
                considerMinimumInterval: true,
                minimumInterval: settings.minimumInterval
            )
            setNextReviewDate(interval: newInterval)
            learningState = LearningState.REVIEW
        }
        learningStepIndex += 1
    }
    
    private mutating func handleReviewActionGoodReview() {
        settings.easeFactor = calculateModifiedFactor(
            baseFactor: settings.easeFactor,
            factorModifier: settings.normalFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: currentReviewInterval,
            factor: settings.easeFactor,
            considerMinimumInterval: true,
            minimumInterval: settings.minimumInterval
        )
        setNextReviewDate(interval: newInterval)
    }
    
    private mutating func handleReviewActionGoodLapse() {
        if let nextStepInterval = settings.getNextLapseStep(lapseIndex: lapseStepIndex) {
            setNextReviewDate(interval: nextStepInterval)
        } else {
            setNextReviewDate(interval: lapseLastReviewInterval)
            learningState = LearningState.REVIEW
        }
        lapseStepIndex += 1
    }
    
    private mutating func handleReviewActionRepeatLearning() {
        let newInterval: TimeInterval = settings.getNextLearningStep(learningIndex: 0)!
        learningStepIndex = 1
        setNextReviewDate(interval: newInterval)
    }
    
    private mutating func handleReviewActionRepeatReviewLapse() {
        lapseStepIndex = 0
        settings.easeFactor = calculateModifiedFactor(
            baseFactor: settings.easeFactor,
            factorModifier: settings.lapseFactorModifier
        )
        let previousReviewInterval = learningState == .REVIEW ? currentReviewInterval : lapseLastReviewInterval
        lapseLastReviewInterval = calculateInterval(
            baseInterval: previousReviewInterval,
            intervalModifier: settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: settings.minimumInterval
        )
        if let newInterval = settings.getNextLapseStep(lapseIndex: lapseStepIndex) {
            setNextReviewDate(interval: newInterval)
            learningState = LearningState.LAPSE
        } else {
            setNextReviewDate(interval: lapseLastReviewInterval)
            learningState = LearningState.REVIEW
        }
        lapseStepIndex += 1
    }
    
    private mutating func handleReviewActionEasyLearning() {
        if let _ = settings.getNextLearningStep(learningIndex: learningStepIndex) {
            setNextReviewDate(interval: settings.graduationInterval)
        } else {
            settings.easeFactor = calculateModifiedFactor(
                baseFactor: settings.easeFactor,
                factorModifier: settings.easyFactorModifier
            )
            let newInterval = calculateInterval(
                baseInterval: currentReviewInterval,
                factor: settings.easeFactor,
                intervalModifier: settings.easyIntervalModifier,
                considerMinimumInterval: true,
                minimumInterval: settings.minimumInterval
            )
            setNextReviewDate(interval: newInterval)
        }
        learningStepIndex += 1
        learningState = LearningState.REVIEW
    }
    
    private mutating func handleReviewActionEasyReview() {
        settings.easeFactor = calculateModifiedFactor(
            baseFactor: settings.easeFactor,
            factorModifier: settings.easyFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: currentReviewInterval,
            factor: settings.easeFactor,
            intervalModifier: settings.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: settings.minimumInterval
        )
        setNextReviewDate(interval: newInterval)
    }
    
    private mutating func handleReviewActionEasyLapse() {
        settings.easeFactor = calculateModifiedFactor(
            baseFactor: settings.easeFactor,
            factorModifier: settings.easyFactorModifier
        )
        let newInterval = calculateInterval(
            baseInterval: lapseLastReviewInterval,
            intervalModifier: settings.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: settings.minimumInterval
        )
        setNextReviewDate(interval: newInterval)
        learningState = LearningState.REVIEW
    }
    
    private mutating func handleReviewActionHardLearning() {
        let newInterval = currentReviewInterval
        setNextReviewDate(interval: newInterval)
    }
    
    private mutating func handleReviewActionHardReviewLapse() {
        settings.easeFactor = calculateModifiedFactor(
            baseFactor: settings.easeFactor,
            factorModifier: settings.hardFactorModifier
        )
        let newInterval = currentReviewInterval
        setNextReviewDate(interval: newInterval)
    }
    
    private mutating func handleReviewActionCustomIntervalAllStates(customInterval: TimeInterval) {
        setNextReviewDate(interval: customInterval)
        learningState = LearningState.REVIEW
    }
    
    private mutating func initializeCardSchedule() {
        let interval = settings.getNextLearningStep(learningIndex: 0) ?? settings.minimumInterval
        setNextReviewDate(interval: interval)
        learningStepIndex = 1
    }
    
    private mutating func setNextReviewDate(interval: TimeInterval) {
        currentReviewInterval = interval
        lastReviewDate = Date()
        nextReviewDate = DateInterval(start: Date(), duration: interval).end
    }
    
    private mutating func incrementReviewCount() {
        reviewCount += 1
    }
    
    func calculateModifiedFactor(baseFactor: Float, factorModifier: Float) -> Float {
        ((baseFactor + factorModifier) * 100).rounded() / 100
    }
    
    func calculateInterval(baseInterval: TimeInterval, factor: Float = 1.0, intervalModifier: Float = 1.0,
                           considerMinimumInterval: Bool = false, minimumInterval: TimeInterval = 0
    ) -> TimeInterval
    {
        let newInterval = round(Double(baseInterval) * Double(factor) * Double(intervalModifier))
        return newInterval < minimumInterval && considerMinimumInterval ? minimumInterval : newInterval
    }
}
