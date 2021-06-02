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
        var updatedScheduler = scheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, updatedScheduler.settings.lapseSteps[0])
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
        for i in 1...updatedScheduler.settings.lapseSteps.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
            XCTAssertEqual(updatedScheduler.currentReviewInterval, updatedScheduler.settings.lapseSteps[i])
            XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
        }
    }
    
    func testGraduateFromReviewToLapseToReview() throws {
        var updatedScheduler = scheduler
        let assertedPostLapseInterval = scheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: scheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: scheduler.settings.minimumInterval
        )
        let assertedPostLapseEaseFactor = scheduler.calculateModifiedFactor(
            for: scheduler.settings.easeFactor,
            with: scheduler.settings.lapseFactorModifier
        )
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        for _ in 1...updatedScheduler.settings.lapseSteps.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        }
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedPostLapseEaseFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedPostLapseInterval)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }
    
    func testGraduateFromReviewToLapseToReviewWithoutLapses() throws {
        var updatedScheduler = scheduler
        updatedScheduler.settings.lapseSteps = Array()
        let assertedFactor = updatedScheduler.calculateModifiedFactor(
            for: updatedScheduler.settings.easeFactor,
            with: updatedScheduler.settings.lapseFactorModifier
        )
        let assertedInterval = updatedScheduler.calculateInterval(
            baseInterval: updatedScheduler.currentReviewInterval,
            factor: updatedScheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: updatedScheduler.settings.minimumInterval
        )
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }
    
    func testSkipToReview() throws {
        var updatedScheduler = scheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        let assertedEaseFactor = updatedScheduler.calculateModifiedFactor(
            for: updatedScheduler.settings.easeFactor,
            with: updatedScheduler.settings.easyFactorModifier
        )
        let assertedPostLapseEaseFactor = updatedScheduler.calculateInterval(
            baseInterval: scheduler.currentReviewInterval,
            factor: updatedScheduler.settings.lapseSetBackFactor
        )
        let assertedInterval = updatedScheduler.calculateInterval(
            baseInterval: assertedPostLapseEaseFactor,
            factor: updatedScheduler.settings.easyIntervalModifier,
            considerMinimumInterval: true,
            minimumInterval: updatedScheduler.settings.minimumInterval
        )
        updatedScheduler = updatedScheduler.processedReviewAction(as: .EASY)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedEaseFactor)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }
    
    func testHardLapse() throws {
        var updatedScheduler = scheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        let previousScheduler = updatedScheduler
        let assertedEaseFactor = updatedScheduler.calculateModifiedFactor(
            for: previousScheduler.settings.easeFactor,
            with: previousScheduler.settings.hardFactorModifier
        )
        updatedScheduler = updatedScheduler.processedReviewAction(as: .HARD)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, previousScheduler.currentReviewInterval)
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedEaseFactor)
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
    }
    
    func testRepeatLapseThenGraduate() throws {
        var updatedScheduler = scheduler
        let firstAssertedPostLapseInterval = updatedScheduler.calculateInterval(
            baseInterval: updatedScheduler.currentReviewInterval,
            factor: updatedScheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: updatedScheduler.settings.minimumInterval
        )
        let secondAssertedPostLapseInterval = updatedScheduler.calculateInterval(
            baseInterval: firstAssertedPostLapseInterval,
            factor: updatedScheduler.settings.lapseSetBackFactor,
            considerMinimumInterval: true,
            minimumInterval: updatedScheduler.settings.minimumInterval
        )
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, updatedScheduler.settings.lapseSteps[0])
        let assertedFactor = updatedScheduler.calculateModifiedFactor(
            for: updatedScheduler.settings.easeFactor,
            with: updatedScheduler.settings.lapseFactorModifier
        )
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        for _ in 0...updatedScheduler.settings.lapseSteps.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        }
        XCTAssertEqual(updatedScheduler.settings.easeFactor, assertedFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, secondAssertedPostLapseInterval)
    }
    
    func testLeaveLapseWithCustomInterval() throws {
        var updatedScheduler = scheduler
        let customInterval: TimeInterval = 3024000
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
        
        updatedScheduler = updatedScheduler.processedReviewAction(as: .CUSTOMINTERVAL(3024000))
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
        XCTAssertEqual(updatedScheduler.currentReviewInterval, customInterval)
    }
}
