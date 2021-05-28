//
//  SchedulerLapsingTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 28.05.21.
//

import Foundation
import XCTest
@testable import SRL

class SchedulerLapsingTest: XCTestCase {
    private var scheduler: Scheduler = Scheduler()
    private var formatter = DateFormatter()

    override func setUpWithError() throws {
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let lastReviewDate: Date = Date()
        let reviewInterval: TimeInterval = 3888000
        let nextReviewDate: Date = DateInterval(start: lastReviewDate, duration: reviewInterval).end
        scheduler = Scheduler(
            settings: SchedulerSettings(),
            learningState: .REVIEW,
            lastReviewDate: lastReviewDate,
            nextReviewDate: nextReviewDate,
            cardStudyCount: 4,
            learningStepIndex: 4,
            lapseStepIndex: 0,
            currentReviewInterval: reviewInterval
        )
    }

    func testMoveThroughLapseSteps() throws {
        scheduler.processReviewAction(action: .REPEAT)
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.lapseSteps[0])
        XCTAssertEqual(scheduler.learningState, .LAPSE)
        for i in 1...scheduler.settings.lapseSteps.count - 1 {
            scheduler.processReviewAction(action: .GOOD)
            XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.lapseSteps[i])
            XCTAssertEqual(scheduler.learningState, .LAPSE)
        }
    }
    
    func testGraduateFromReviewToLapseToReview() throws {
        let assertedPostLapseInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        let assertedPostLapseEaseFactor = scheduler.calculateModifiedFactor(
            baseFactor: scheduler.settings.easeFactor,
            factorModifier: scheduler.settings.lapseFactorModifier
        )
        scheduler.processReviewAction(action: .REPEAT)
        for _ in 1...scheduler.settings.lapseSteps.count - 1 {
            scheduler.processReviewAction(action: .GOOD)
        }
        scheduler.processReviewAction(action: .GOOD)
        XCTAssertEqual(scheduler.settings.easeFactor, assertedPostLapseEaseFactor)
        XCTAssertEqual(scheduler.currentReviewInterval, assertedPostLapseInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
    }
    
    func testGraduateFromReviewToLapseToReviewWithoutLapses() throws {
        scheduler.settings.lapseSteps = Array()
        let assertedFactor = scheduler.calculateModifiedFactor(
            baseFactor: scheduler.settings.easeFactor,
            factorModifier: scheduler.settings.lapseFactorModifier
        )
        let assertedInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        scheduler.processReviewAction(action: .REPEAT)
        XCTAssertEqual(scheduler.settings.easeFactor, assertedFactor)
        XCTAssertEqual(scheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
    }
    
    func testSkipToReview() throws {
        let previousScheduler = scheduler
        scheduler.processReviewAction(action: .REPEAT)
        let assertedEaseFactor = scheduler.calculateModifiedFactor(
            baseFactor: scheduler.settings.easeFactor,
            factorModifier: scheduler.settings.easyFactorModifier
        )
        let assertedPostLapseEaseFactor = scheduler.calculateInterval(
            baseInterval: previousScheduler.currentReviewInterval,
            factor: scheduler.settings.lapseSetBackFactor
        )
        let assertedInterval = scheduler.calculateInterval(
            baseInterval: assertedPostLapseEaseFactor,
            factor: scheduler.settings.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        scheduler.processReviewAction(action: .EASY)
        XCTAssertEqual(scheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(scheduler.settings.easeFactor, assertedEaseFactor)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
        
    }
    
    func testHardLapse() throws {
        scheduler.processReviewAction(action: .REPEAT)
        let previousScheduler = scheduler
        let assertedEaseFactor = scheduler.calculateModifiedFactor(
            baseFactor: previousScheduler.settings.easeFactor,
            factorModifier: previousScheduler.settings.hardFactorModifier
        )
        scheduler.processReviewAction(action: .HARD)
        XCTAssertEqual(scheduler.currentReviewInterval, previousScheduler.currentReviewInterval)
        XCTAssertEqual(scheduler.settings.easeFactor, assertedEaseFactor)
        XCTAssertEqual(scheduler.learningState, .LAPSE)
    }
    
    func testRepeatLapseThenGraduate() throws {
        let firstAssertedPostLapseInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        let secondAssertedPostLapseInterval = scheduler.calculateInterval(
            baseInterval: firstAssertedPostLapseInterval,
            factor: scheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        scheduler.processReviewAction(action: .REPEAT)
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.lapseSteps[0])
        let assertedFactor = scheduler.calculateModifiedFactor(
            baseFactor: scheduler.settings.easeFactor,
            factorModifier: scheduler.settings.lapseFactorModifier
        )
        scheduler.processReviewAction(action: .GOOD)
        scheduler.processReviewAction(action: .REPEAT)
        for _ in 0...scheduler.settings.lapseSteps.count - 1 {
            scheduler.processReviewAction(action: .GOOD)
        }
        XCTAssertEqual(scheduler.settings.easeFactor, assertedFactor)
        XCTAssertEqual(scheduler.currentReviewInterval, secondAssertedPostLapseInterval)
    }
    
    func testLeaveLapseWithCustomInterval() throws {
        let customInterval: TimeInterval = 3024000
        scheduler.processReviewAction(action: .REPEAT)
        XCTAssertEqual(scheduler.learningState, .LAPSE)
        
        scheduler.processReviewAction(action: .CUSTOMINTERVAL(interval: 3024000))
        XCTAssertEqual(scheduler.learningState, .REVIEW)
        XCTAssertEqual(scheduler.currentReviewInterval, customInterval)
    }
}
