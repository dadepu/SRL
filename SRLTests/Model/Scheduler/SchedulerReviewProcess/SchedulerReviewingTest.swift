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
    private var schedulePreset: SchedulePreset?
    private var scheduler: Scheduler?
    private var formatter = DateFormatter()

    override func setUpWithError() throws {
        schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        

        let lastReviewDate = ReviewDate.makeFromCurrentDate()
        let reviewInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: 3888000)
        let nextReviewDate = ReviewDate.makeFromDate(date: DateInterval(start: lastReviewDate.date, duration: reviewInterval.intervalSeconds).end)
        let learningStep = LearningStep.makeNewUnitTestOnly(index: 4)
        
        scheduler = Scheduler(
            schedulePreset: schedulePreset!,
            easeFactor: schedulePreset!.easeFactor,
            learningState: .REVIEW,
            lastReviewDate: lastReviewDate,
            nextReviewDate: nextReviewDate,
            cardStudyCount: 4,
            learningStep: learningStep,
            lapseStep: nil,
            currentReviewInterval: reviewInterval
        )
    }

    func testNormalReview() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        let assertedEaseFactor = scheduler!.easeFactor.appliedFactorModifierOrMinimum(modifier: schedulePreset!.normalFactorModifier)
        let assertedInterval = scheduler!.currentReviewInterval.nextReviewInterval(easeFactor: assertedEaseFactor)

        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, assertedEaseFactor.easeFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, assertedInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testEasyReview() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .EASY)
        let assertedEaseFactor = scheduler!.easeFactor.appliedFactorModifierOrMinimum(modifier: schedulePreset!.easyFactorModifier)
        let assertedInterval = scheduler!.currentReviewInterval.nextReviewInterval(easeFactor: assertedEaseFactor, intervalModifier: scheduler!.schedulePreset.easyIntervalModifier)
    
        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, assertedEaseFactor.easeFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, assertedInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testHardReview() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = scheduler!.processedReviewAction(as: .HARD)
        let assertedEaseFactor = scheduler!.easeFactor.appliedFactorModifierOrMinimum(modifier: schedulePreset!.hardFactorModifier)
        
        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, assertedEaseFactor.easeFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, scheduler!.currentReviewInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testRepeatReview() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        let assertedEaseFactor = scheduler!.easeFactor.appliedFactorModifierOrMinimum(modifier: schedulePreset!.lapseFactorModifier)
        
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.getNextLapseStep(lapseIndex: 0))
        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, assertedEaseFactor.easeFactor)
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
    }
}
