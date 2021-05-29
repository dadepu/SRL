//
//  ReviewQueueSynchronisationTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 29.05.21.
//

import Foundation
import XCTest
@testable import SRL

class ReviewQueueSynchronisationTest: XCTestCase {
    private var deck: Deck?
    private var reviewQueue: Reviewable?
    private var formatter = DateFormatter()
    
    override func setUpWithError() throws {
        deck = Deck(name: "TH-Koeln DB2")
        reviewQueue = deck?.createReviewableQueue(f: ReviewQueue.createInstance(deck:cards:))
        formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    }
    
    func testNewCardSynchronisation() throws {
        let deck: Deck = self.deck!
        let reviewQueue: Reviewable = self.reviewQueue!
        
        XCTAssertEqual(deck.cards.count, 0)
        XCTAssertEqual(reviewQueue.reviewableCards, 0)
        XCTAssertNil(reviewQueue.nextCard)
        
        let newCardWithPostDate = createCard(lastReview: "01.03.2021 11:09:00", interval: 3283200)
        deck.addCard(card: newCardWithPostDate)
        XCTAssertEqual(deck.cards.count, 1)
        XCTAssertEqual(reviewQueue.reviewableCards, 1)
        XCTAssertEqual(reviewQueue.nextCard!.id, newCardWithPostDate.id)
        
        let newCardWithFutureDate = createCard(lastReview: "01.03.2030 11:09:00", interval: 3283200)
        deck.addCard(card: newCardWithFutureDate)
        XCTAssertEqual(deck.cards.count, 2)
        XCTAssertEqual(reviewQueue.reviewableCards, 1)
        XCTAssertEqual(reviewQueue.nextCard!.id, newCardWithPostDate.id)
    }
    
    func testCardProcessActionSynchronisation() throws {
        let deck: Deck = self.deck!
        let reviewQueue: Reviewable = self.reviewQueue!
        
        let newCardWithPostDate = createCard(lastReview: "01.03.2021 11:09:00", interval: 3283200)
        deck.addCard(card: newCardWithPostDate)
        XCTAssertEqual(reviewQueue.reviewableCards, 1)
        
        var nextCard = reviewQueue.nextCard!
        nextCard.schedule.processReviewAction(action: .GOOD)
        try deck.updateCard(card: nextCard)
        XCTAssertEqual(reviewQueue.reviewableCards, 0)
    }
    
    
    private func createCard(lastReview: String, interval: TimeInterval) -> Card {
        let lastReviewDate = formatter.date(from: lastReview)!
        let nextReviewDate = DateInterval(start: lastReviewDate, duration: interval).end
        let scheduler = Scheduler(
            settings: SchedulerSettings(),
            learningState: .REVIEW,
            lastReviewDate: lastReviewDate,
            nextReviewDate: nextReviewDate,
            cardStudyCount: 5,
            learningStepIndex: 4,
            lapseStepIndex: 4,
            currentReviewInterval: interval
        )
        return Card(scheduler: scheduler)
    }
}
