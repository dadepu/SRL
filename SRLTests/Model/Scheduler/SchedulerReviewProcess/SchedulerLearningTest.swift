//
//  SchedulerLearningTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 28.05.21.
//

import Foundation
import XCTest
@testable import SRL

class SchedulerLearningTest: XCTestCase {
    private var schedulePreset: SchedulePreset?
    private var scheduler: Scheduler?

    
    override func setUpWithError() throws {
        schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        scheduler = Scheduler(schedulePreset: schedulePreset!)
    }

    func testMoveThroughLearningStepsToGraduation() throws {
        var updatedScheduler = scheduler!
        for i in 0...updatedScheduler.schedulePreset.learningSteps.learningStepsSeconds.count - 1 {
            if i == 0 {
                XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, 0)
            } else {
                XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.learningSteps.learningStepsSeconds[i])
            }
            XCTAssertEqual(updatedScheduler.learningState, .LEARNING)
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        }
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.graduationInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.easeFactor, scheduler!.schedulePreset.easeFactor)
        XCTAssertEqual(updatedScheduler.learningState, .LEARNING)
    }
    
    func testSkipLearningStepsToGraduation() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = scheduler!.processedReviewAction(as: .EASY)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.graduationInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
        XCTAssertEqual(updatedScheduler.easeFactor, scheduler!.schedulePreset.easeFactor)
    }

    func testGraduateFromLearningToReview() throws {
        var updatedScheduler = scheduler!
        for _ in 0...updatedScheduler.schedulePreset.learningSteps.learningStepsSeconds.count - 1 {
            updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        }
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.graduationInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.learningState, .LEARNING)
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
        XCTAssert(updatedScheduler.currentReviewInterval.intervalSeconds > updatedScheduler.schedulePreset.graduationInterval.intervalSeconds)
    }

    func testRepeatLearningStep() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        let intermediateStatusScheduler = updatedScheduler
        updatedScheduler = updatedScheduler.processedReviewAction(as: .HARD)

        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, intermediateStatusScheduler.currentReviewInterval.intervalSeconds)
        XCTAssertEqual(updatedScheduler.reviewCount - 1, intermediateStatusScheduler.reviewCount)
        XCTAssertEqual(updatedScheduler.easeFactor.easeFactor, intermediateStatusScheduler.schedulePreset.easeFactor.easeFactor)
    }

    func testRepeatLearningProcess() throws {
        var updatedScheduler = scheduler!
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)
        updatedScheduler = updatedScheduler.processedReviewAction(as: .GOOD)

        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, updatedScheduler.schedulePreset.getNextLearningStep(learningIndex: 2))
        updatedScheduler = updatedScheduler.processedReviewAction(as: .REPEAT)
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, scheduler!.schedulePreset.getNextLapseStep(lapseIndex: 0))
        XCTAssertEqual(updatedScheduler.easeFactor, scheduler!.schedulePreset.easeFactor)
    }

    func testCustomLearningIntervalFromLearningToReview() throws {
        var updatedScheduler = scheduler!
        let customInterval: TimeInterval = 3024000
        XCTAssertEqual(updatedScheduler.learningState, .LEARNING)
        updatedScheduler = updatedScheduler.processedReviewAction(as: .CUSTOMINTERVAL(customInterval))
        XCTAssertEqual(updatedScheduler.currentReviewInterval.intervalSeconds, customInterval)
        XCTAssertEqual(updatedScheduler.learningState, .REVIEW)
    }
}
