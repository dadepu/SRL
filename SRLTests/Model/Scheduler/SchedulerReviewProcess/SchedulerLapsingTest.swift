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
    private var schedulePreset: SchedulePreset?
    private var scheduler: Scheduler?
    private var formatter = DateFormatter()

    override func setUpWithError() throws {
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        
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

    func testMoveThroughLapseSteps() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.lapseSteps.lapseStepsSeconds[0])
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
        for i in 1...updatedScheduler.schedulePreset.lapseSteps.lapseStepsSeconds.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
            XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.lapseSteps.lapseStepsSeconds[i])
            XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
        }
    }

    func testGraduateFromReviewToLapseToReview() throws {
        var updatedScheduler = scheduler!
        let assertedPostLapseInterval = LapseStep.makeNew(previousInterval: scheduler!.currentReviewInterval, setbackFactor: scheduler!.schedulePreset.lapseSetbackFactor).previousReviewIntervalSetbackIncluded
        let assertedPostLapseEaseFactor = scheduler!.easeFactor.appliedFactorModifierOrMinimum(modifier: scheduler!.schedulePreset.lapseFactorModifier)
        
        
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        for _ in 1...updatedScheduler.schedulePreset.lapseSteps.lapseStepsSeconds.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        }
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, assertedPostLapseEaseFactor.easeFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, assertedPostLapseInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

//    func testGraduateFromReviewToLapseToReviewWithoutLapses() throws {
//        var customSchedulePreset = SchedulePreset(name: "TEST")
//        try! customSchedulePreset.setLapseSteps(steps: [])
//
//        var updatedScheduler = scheduler!.hasSetSchedulePreset(customSchedulePreset)
//
//        let assertedFactor = updatedScheduler.calculateModifiedFactor(
//            for: updatedScheduler.easeFactor,
//            with: updatedScheduler.schedulePreset.lapseFactorModifier
//        )
//        let assertedInterval = updatedScheduler.calculateInterval(
//            baseInterval: updatedScheduler.currentReviewInterval,
//            factor: updatedScheduler.schedulePreset.lapseSetBackFactor,
//            considerMinimumInterval: true,
//            minimumInterval: updatedScheduler.schedulePreset.minimumIntervalInSeconds
//        )
//        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
//        XCTAssertEqual(updatedScheduler.easeFactor, assertedFactor)
//        XCTAssertEqual(updatedScheduler.currentReviewInterval, assertedInterval)
//        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
//    }

    func testSkipToReview() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        let assertedEaseFactor = updatedScheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: updatedScheduler.schedulePreset.easyFactorModifier)
        let assertedInterval = updatedScheduler.lapseStep!.previousReviewIntervalSetbackIncluded.nextReviewInterval(easeFactor: assertedEaseFactor, intervalModifier: updatedScheduler.schedulePreset.easyIntervalModifier, minimumInterval: updatedScheduler.schedulePreset.minimumInterval)
  
        updatedScheduler = updatedScheduler.processedReviewAction(as: .EASY)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, assertedInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.easeFactor, assertedEaseFactor)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }

    func testHardLapse() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        let previousScheduler = updatedScheduler
        let assertedEaseFactor = updatedScheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: updatedScheduler.schedulePreset.hardFactorModifier)

        updatedScheduler = updatedScheduler.processedReviewAction(as: .HARD)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, previousScheduler.currentReviewInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.easeFactor, assertedEaseFactor)
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)
    }

    func testRepeatLapseThenGraduate() throws {
        var updatedScheduler = scheduler!
        let firstAssertedPostLapseInterval = LapseStep.makeNew(previousInterval: updatedScheduler.currentReviewInterval, setbackFactor: updatedScheduler.schedulePreset.lapseSetbackFactor, minimumInterval: updatedScheduler.schedulePreset.minimumInterval).previousReviewIntervalSetbackIncluded
        let secondAssertedPostLapseInterval = LapseStep.makeNew(previousInterval: firstAssertedPostLapseInterval, setbackFactor: updatedScheduler.schedulePreset.lapseSetbackFactor, minimumInterval: updatedScheduler.schedulePreset.minimumInterval).previousReviewIntervalSetbackIncluded
        
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.lapseSteps.lapseStepsSeconds[0])
        
        let assertedEaseFactor = updatedScheduler.easeFactor.appliedFactorModifierOrMinimum(modifier: updatedScheduler.schedulePreset.lapseFactorModifier)
        
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        for _ in 0...updatedScheduler.schedulePreset.lapseSteps.lapseStepsSeconds.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        }
        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, assertedEaseFactor.easeFactor)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, secondAssertedPostLapseInterval.intervalSeconds)
    }

    func testLeaveLapseWithCustomInterval() throws {
        var updatedScheduler = scheduler!
        let customInterval: TimeInterval = 3024000
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.learningState, .LAPSE)

        updatedScheduler = updatedScheduler.processedReviewAction(as: .CUSTOMINTERVAL(3024000))
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, customInterval)
    }
}
