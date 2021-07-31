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
    private var schedulePreset: SchedulePreset?
    private var scheduler: Scheduler?
    private var formatter = DateFormatter()

    
    override func setUpWithError() throws {
        schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        scheduler = Scheduler(schedulePreset: schedulePreset!)
        
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    }
    
    
    
    func testReviewCurrentDate() throws {
        let scheduler = self.scheduler!
        XCTAssert(scheduler.nextReviewDate.date <= Date())
        XCTAssertTrue(scheduler.isDueForReview)
    }
    
    func testReviewDuePastDate() throws {
        let lastReviewDate = ReviewDate.makeFromDate(date: formatter.date(from: "01.03.2021 10:35:00")!)
        let reviewInterval = ReviewInterval.makeFromTimeInterval(intervalSeconds: 1274400)
        let nextReviewDate = ReviewDate.makeFromDate(date: DateInterval(start: lastReviewDate.date, duration: reviewInterval.intervalSeconds).end)
        let learningStep = LearningStep.makeNewUnitTestOnly(index: 2)

        let schedulerPastReviewDate = Scheduler(
            schedulePreset: schedulePreset!,
            easeFactor: schedulePreset!.easeFactor,
            learningState: .LEARNING,
            lastReviewDate: lastReviewDate,
            nextReviewDate: nextReviewDate,
            cardStudyCount: 2,
            learningStep: learningStep,
            lapseStep: nil,
            currentReviewInterval: reviewInterval
        )
        XCTAssert(schedulerPastReviewDate.nextReviewDate.date < Date())
        XCTAssertTrue(schedulerPastReviewDate.isDueForReview)
    }

    func testNextReviewDateCalculation() throws {
        let newSchedule = scheduler!.processedReviewAction(as: .GOOD)
        let assertedReviewDate = DateInterval(start: newSchedule.lastReviewDate.date, duration: newSchedule.currentReviewInterval.intervalSeconds).end

        XCTAssert(newSchedule.lastReviewDate.date <= Date())
        XCTAssertEqual(newSchedule.nextReviewDate.date, assertedReviewDate)
    }
}
