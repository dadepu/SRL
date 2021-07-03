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
    private var deck: Deck?
    private var schedulePreset: SchedulePreset?
    private var scheduler: Scheduler?
    private var formatter = DateFormatter()

    
    override func setUpWithError() throws {
        deck = Deck(name: "UNIT Test")
        schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        scheduler = Scheduler(deck: deck!, schedulePreset: schedulePreset!)
        
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    }
    
    
    
    func testReviewIsDueFutureDate() throws {
        let scheduler = self.scheduler!
        XCTAssert(scheduler.nextReviewDate > Date())
        XCTAssertFalse(scheduler.isDueForReview)
    }
    
    func testReviewIsDuePastDate() throws {
        let lastReviewDate: Date = formatter.date(from: "01.03.2021 10:35:00")!
        let reviewInterval: TimeInterval = 1274400
        let nextReviewDate: Date = DateInterval(start: lastReviewDate, duration: reviewInterval).end
        
        let schedulerPastReviewDate = Scheduler(
            deck: deck!,
            schedulePreset: schedulePreset!,
            easeFactor: schedulePreset!.easeFactor,
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
        let newSchedule = scheduler!.processedReviewAction(as: .GOOD)
        let assertedReviewDate = DateInterval(start: newSchedule.lastReviewDate, duration: newSchedule.currentReviewInterval).end
        
        XCTAssert(newSchedule.lastReviewDate <= Date())
        XCTAssertEqual(newSchedule.nextReviewDate, assertedReviewDate)
    }
}
