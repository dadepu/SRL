////
////  SchedulerReviewingTest.swift
////  SRLTests
////
////  Created by Daniel Koellgen on 28.05.21.
////
//
//import Foundation
//import XCTest
//@testable import SRL
//
//class SchedulerReviewingTest: XCTestCase {
//    private var schedulePreset: SchedulePreset?
//    private var scheduler: Scheduler?
//    private var formatter = DateFormatter()
//
//    override func setUpWithError() throws {
//        schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
//        
//        formatter = DateFormatter()
//        formatter.timeZone = .current
//        formatter.locale = .current
//        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
//        
//
//        let lastReviewDate: Date = Date()
//        let reviewInterval: TimeInterval = 3888000
//        let nextReviewDate: Date = DateInterval(start: lastReviewDate, duration: reviewInterval).end
//        scheduler = Scheduler(
//            schedulePreset: schedulePreset!,
//            easeFactor: schedulePreset!.easeFactor,
//            learningState: .REVIEW,
//            lastReviewDate: lastReviewDate,
//            nextReviewDate: nextReviewDate,
//            cardStudyCount: 4,
//            learningStepIndex: 4,
//            lapseStepIndex: 0,
//            currentReviewInterval: reviewInterval
//        )
//    }
//
//    func testNormalReview() throws {
//        var updatedScheduler = scheduler!
//        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
//        let assertedReviewFactor: Float = scheduler!.calculateModifiedFactor(
//            for: scheduler!.easeFactor,
//            with: scheduler!.schedulePreset.normalFactorModifier
//        )
//        let assertedInterval: TimeInterval = scheduler!.calculateInterval(
//            baseInterval: scheduler!.currentReviewInterval,
//            factor: assertedReviewFactor
//        )
//        XCTAssertEqual(updatedScheduler.easeFactor, assertedReviewFactor)
//        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
//        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
//    }
//
//    func testEasyReview() throws {
//        var updatedScheduler = scheduler!
//        updatedScheduler = updatedScheduler.processedReviewAction(as: .EASY)
//        let assertedReviewFactor: Float = scheduler!.calculateModifiedFactor(
//            for: scheduler!.easeFactor,
//            with: scheduler!.schedulePreset.easyFactorModifier
//        )
//        let assertedInterval: TimeInterval = scheduler!.calculateInterval(
//            baseInterval: scheduler!.currentReviewInterval,
//            factor: assertedReviewFactor,
//            intervalModifier: scheduler!.schedulePreset.easyIntervalModifier
//        )
//        XCTAssertEqual(updatedScheduler.easeFactor, assertedReviewFactor)
//        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
//        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
//    }
//
//    func testHardReview() throws {
//        var updatedScheduler = scheduler!
//        updatedScheduler = scheduler!.processedReviewAction(as: .HARD)
//        let assertedReviewFactor: Float = scheduler!.calculateModifiedFactor(
//            for: scheduler!.easeFactor,
//            with: scheduler!.schedulePreset.hardFactorModifier
//        )
//        XCTAssertEqual(updatedScheduler.easeFactor, assertedReviewFactor)
//        XCTAssertEqual(updatedScheduler.currentReviewInterval, scheduler!.currentReviewInterval)
//        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
//    }
//
//    func testRepeatReview() throws {
//        var updatedScheduler = scheduler!
//        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
//        let assertedReviewFactor: Float = scheduler!.calculateModifiedFactor(
//            for: scheduler!.easeFactor,
//            with: scheduler!.schedulePreset.lapseFactorModifier
//        )
//        XCTAssertEqual(updatedScheduler.currentReviewInterval, updatedScheduler.schedulePreset.lapseStepsInSeconds[0])
//        XCTAssertEqual(updatedScheduler.easeFactor, assertedReviewFactor)
//        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
//    }
//}
