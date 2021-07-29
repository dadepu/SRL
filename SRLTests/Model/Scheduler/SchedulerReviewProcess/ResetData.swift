//
//  ResetData.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 29.07.21.
//

import Foundation
import XCTest
@testable import SRL

class SchedulerFunctionalityTest: XCTestCase {
    
    func testResetApp() {
        let deckRepository = DeckRepository.getInstance()
        let cardRepository = CardRepository.getInstance()
        let schedulerRepository = SchedulerRepository.getInstance()
        let scheduleRepository = SchedulePresetRepository.getInstance()
        let reviewQueue = ReviewQueueRepository.getInstance()
        
        deckRepository.deleteAllDecks()
        cardRepository.deleteAllCards()
        schedulerRepository.deleteAllSchedulers()
        scheduleRepository.deleteAllSchedulePresets()
        reviewQueue.deleteReviewQueue()
    }
}
