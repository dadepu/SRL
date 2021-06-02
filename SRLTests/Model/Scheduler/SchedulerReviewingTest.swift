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
        var updatedScheduler = scheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        let assertedReviewFactor: Float = scheduler.calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.normalFactorModifier
        )
        let assertedInterval: TimeInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: assertedReviewFactor
        )
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testEasyReview() throws {
        var updatedScheduler = scheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .EASY)
        let assertedReviewFactor: Float = scheduler.calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.easyFactorModifier
        )
        let assertedInterval: TimeInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: assertedReviewFactor,
            intervalModifier: scheduler.settings.easyIntervalModifier
        )
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testHardReview() throws {
        var updatedScheduler = scheduler
        updatedScheduler = scheduler.processedReviewAction(as: .HARD)
        let assertedReviewFactor: Float = scheduler.calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.hardFactorModifier
        )
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, scheduler.currentReviewInterval)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testRepeatReview() throws {
        var updatedScheduler = scheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        let assertedReviewFactor: Float = scheduler.calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.lapseFactorModifier
        )
        XCTAssertEqual(updatedScheduler.currentReviewInterval, updatedScheduler.settings.lapseSteps[0])
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedReviewFactor)
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
    }
}
