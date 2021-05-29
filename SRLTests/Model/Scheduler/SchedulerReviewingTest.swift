//
//  SchedulerReviewingTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 28.05.21.
//

import Foundation
import XCTest
@testable import SRL

class SchedulerReviewingTest: XCTestCase {
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

    func testNormalReview() throws {
        let previousScheduler = scheduler
        scheduler.processReviewAction(action: .GOOD)
        let assertedReviewFactor: Float = previousScheduler.calculateModifiedFactor(
            baseFactor: previousScheduler.settings.easeFactor,
            factorModifier: previousScheduler.settings.normalFactorModifier
        )
        let assertedInterval: TimeInterval = previousScheduler.calculateInterval(
            baseInterval: previousScheduler.currentReviewInterval,
            factor: assertedReviewFactor
        )
        XCTAssertEqual(scheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(scheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
    }
    
    func testEasyReview() throws {
        let previousScheduler = scheduler
        scheduler.processReviewAction(action: .EASY)
        let assertedReviewFactor: Float = previousScheduler.calculateModifiedFactor(
            baseFactor: previousScheduler.settings.easeFactor,
            factorModifier: previousScheduler.settings.easyFactorModifier
        )
        let assertedInterval: TimeInterval = previousScheduler.calculateInterval(
            baseInterval: previousScheduler.currentReviewInterval,
            factor: assertedReviewFactor,
            intervalModifier: previousScheduler.settings.easyIntervalModifier
        )
        XCTAssertEqual(scheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(scheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
    }
    
    func testHardReview() throws {
        let previousScheduler = scheduler
        scheduler.processReviewAction(action: .HARD)
        let assertedReviewFactor: Float = previousScheduler.calculateModifiedFactor(
            baseFactor: previousScheduler.settings.easeFactor,
            factorModifier: previousScheduler.settings.hardFactorModifier
        )
        XCTAssertEqual(scheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(scheduler.currentReviewInterval, previousScheduler.currentReviewInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
    }
    
    func testRepeatReview() throws {
        let previousScheduler = scheduler
        scheduler.processReviewAction(action: .REPEAT)
        let assertedReviewFactor: Float = previousScheduler.calculateModifiedFactor(
            baseFactor: previousScheduler.settings.easeFactor,
            factorModifier: previousScheduler.settings.lapseFactorModifier
        )
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.lapseSteps[0])
        XCTAssertEqual(scheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(scheduler.learningState, .LAPSE)
    }
}
