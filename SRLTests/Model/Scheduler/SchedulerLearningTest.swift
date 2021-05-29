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
    private var scheduler: Scheduler = Scheduler()

    override func setUpWithError() throws {
        scheduler = Scheduler()
    }

    func testMoveThroughLearningStepsToGraduation() throws {
        let initialScheduler = scheduler
        for i in 0...scheduler.settings.learningSteps.count - 1 {
            XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.learningSteps[i])
            XCTAssertEqual(scheduler.learningState, .LEARNING)
            scheduler.processReviewAction(action: .GOOD)
        }
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.graduationInterval)
        XCTAssertEqual(scheduler.settings.easeFactor, initialScheduler.settings.easeFactor)
        XCTAssertEqual(scheduler.learningState, .LEARNING)
    }
    
    func testSkipLearningStepsToGraduation() throws {
        let initialScheduler = scheduler
        scheduler.processReviewAction(action: .EASY)
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.graduationInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
        XCTAssertEqual(scheduler.settings.easeFactor, initialScheduler.settings.easeFactor)
    }
    
    func testGraduateFromLearningToReview() throws {
        for _ in 0...scheduler.settings.learningSteps.count - 1 {
            scheduler.processReviewAction(action: .GOOD)
        }
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.graduationInterval)
        XCTAssertEqual(scheduler.learningState, .LEARNING)
        scheduler.processReviewAction(action: .GOOD)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
        XCTAssert(scheduler.currentReviewInterval > scheduler.settings.graduationInterval)
    }
    
    func testRepeatLearningStep() throws {
        scheduler.processReviewAction(action: .GOOD)
        scheduler.processReviewAction(action: .GOOD)
        let previousScheduler = scheduler
        scheduler.processReviewAction(action: .HARD)
        
        XCTAssertEqual(scheduler.currentReviewInterval, previousScheduler.currentReviewInterval)
        XCTAssertEqual(scheduler.reviewCount - 1, previousScheduler.reviewCount)
        XCTAssertEqual(scheduler.settings.easeFactor, previousScheduler.settings.easeFactor)
    }
    
    func testRepeatLearningProcess() throws {
        let startScheduler = scheduler
        scheduler.processReviewAction(action: .GOOD)
        scheduler.processReviewAction(action: .GOOD)
        
        XCTAssertEqual(scheduler.currentReviewInterval, scheduler.settings.getNextLearningStep(learningIndex: 2))
        scheduler.processReviewAction(action: .REPEAT)
        XCTAssertEqual(scheduler.currentReviewInterval, startScheduler.currentReviewInterval)
        XCTAssertEqual(scheduler.settings.easeFactor, startScheduler.settings.easeFactor)
    }
    
    func testCustomLearningIntervalFromLearningToReview() throws {
        let customInterval: TimeInterval = 3024000
        XCTAssertEqual(scheduler.learningState, .LEARNING)
        scheduler.processReviewAction(action: .CUSTOMINTERVAL(interval: customInterval))
        XCTAssertEqual(scheduler.currentReviewInterval, customInterval)
        XCTAssertEqual(scheduler.learningState, .REVIEW)
    }
}
