//
//  TestResetPersistentData.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 29.07.21.
//

import Foundation
import XCTest
@testable import SRL

class TestResetPersistentData: XCTestCase {
    
    func resetAllAppData() {
        let deckRepository = DeckRepository.getInstance()
        let cardRepository = CardRepository.getInstance()
        let schedulerRepository = SchedulerRepository.getInstance()
        let scheduleRepository = SchedulePresetRepository.getInstance()
        let reviewQueueRepository = ReviewQueueRepository.getInstance()
        let notificationRepository = NotificationRepository.getInstance()
        
        deckRepository.deleteAllDecks()
        cardRepository.deleteAllCards()
        schedulerRepository.deleteAllSchedulers()
        scheduleRepository.deleteAllSchedulePresets()
        reviewQueueRepository.deleteReviewQueue()
        notificationRepository.deleteAllNotifications()
    }
}
