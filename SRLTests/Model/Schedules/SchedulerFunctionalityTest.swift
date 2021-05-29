//
//  SchedulerBasicTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 28.05.21.
//

import Foundation
import XCTest
@testable import SRL

class SchedulerFunctionalityTest: XCTestCase {
    private var scheduler: Scheduler = Scheduler()
    private var formatter = DateFormatter()

    override func setUpWithError() throws {
        scheduler = Scheduler()
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    }
    
    func testReviewIsDueFutureDate() throws {
        let schedulerFutureReviewDate = Scheduler()
        XCTAssert(schedulerFutureReviewDate.nextReviewDate > Date())
        XCTAssertFalse(schedulerFutureReviewDate.isDueForReview)
    }
    
    func testReviewIsDuePastDate() throws {
        let lastReviewDate: Date = formatter.date(from: "01.03.2021 10:35:00")!
        let reviewInterval: TimeInterval = 1274400
        let nextReviewDate: Date = DateInterval(start: lastReviewDate, duration: reviewInterval).end
        let schedulerPastReviewDate = Scheduler(
            settings: SchedulerSettings(),
            learningState: .LEARNING,
            lastReviewDate: lastReviewDate,
            nextReviewDate: nextReviewDate,
            cardStudyCount: 2,
            learningStepIndex: 3,
            lapseStepIndex: 0,
            currentReviewInterval: reviewInterval
        )
        XCTAssert(schedulerPastReviewDate.nextReviewDate < Date())
        XCTAssertTrue(schedulerPastReviewDate.isDueForReview)
    }
    
    func testNextReviewDateCalculation() throws {
        scheduler.processReviewAction(action: .GOOD)
        let assertedReviewDate = DateInterval(start: scheduler.lastReviewDate, duration: scheduler.currentReviewInterval).end
        XCTAssert(scheduler.lastReviewDate <= Date())
        XCTAssertEqual(scheduler.nextReviewDate, assertedReviewDate)
    }
}
