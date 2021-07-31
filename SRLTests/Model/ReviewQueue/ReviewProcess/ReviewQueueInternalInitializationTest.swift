//
//  ReviewQueueInitializationTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 25.07.21.
//

import Foundation
import XCTest
@testable import SRL

class ReviewQueueInternalInitializationTest: XCTestCase {
    private let cardBuilder = TestCoreCardBuilder()
    private let reviewService = ReviewQueueService()
    
    private var reviewQueue: ReviewQueue?
    private var transientDeck: Deck?
    private var transientCard1: Card?
    private var transientCard2: Card?
    private var transientCard3: Card?
    
    
    override func setUpWithError() throws {
        let defaultSchedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        
        transientCard1 = cardBuilder.generateRandomDefaultCard()
        transientCard2 = cardBuilder.generateRandomDefaultCard()
        transientCard3 = cardBuilder.generateRandomDefaultCard()
        transientDeck = Deck(name: "Unit Test", schedulePreset: defaultSchedulePreset)
            .addedCard(card: transientCard1!)
            .addedCard(card: transientCard2!)
            .addedCard(card: transientCard3!)
        
        reviewQueue = ReviewQueue(decks: [transientDeck!], reviewType: .REGULAR)
    }
    
    func testReviewQueueInitializationWithDeck() {
        XCTAssertEqual(reviewQueue!.getReviewableCardCount(), 3)
        XCTAssertEqual(reviewQueue!.queue.count, 2)
        XCTAssertNotNil(reviewQueue!.currentCard)
    }
    
    func testReviewQueueRefreshWithDecksSameCardCountWithUpdatedContent() {
        
    }
    
    func testReviewQueueRefreshWithDecksWithMissingCard() {
        let updatedDeck = transientDeck!.removedCard(cardId: reviewQueue!.currentCard!.id)
        
        let updatedReviewQueue = ReviewQueue(reviewQueue!, decks: [updatedDeck])
        
        XCTAssertEqual(updatedReviewQueue.id, reviewQueue!.id)
        XCTAssertNotEqual(updatedReviewQueue.currentCard!.id, reviewQueue!.currentCard!.id)
        XCTAssertEqual(updatedReviewQueue.getReviewableCardCount(), 2)
    }
    
    func testReviewQueueRefreshWithCardsSameCardCountWithUpdatedContent() {
        let previousCurrentCard = reviewQueue!.currentCard!
        let updatedPreviousCurrentCard = previousCurrentCard.reviewedCard(as: .EASY)
        let updatedCards: [Card] = reviewQueue!.queue + [updatedPreviousCurrentCard]
        
        let updatedReviewQueue = ReviewQueue(reviewQueue!, cards: updatedCards)
        
        XCTAssertEqual(updatedReviewQueue.id, reviewQueue!.id)
        XCTAssertGreaterThan(updatedReviewQueue.currentCard!.dateLastModified, previousCurrentCard.dateLastModified)
        XCTAssertEqual(updatedReviewQueue.currentCard!.dateLastModified, updatedPreviousCurrentCard.dateLastModified)
    }
    
    func testReviewQueueRefreshWithCardsWithMissingCard() {
        let _ = reviewQueue!.currentCard
        let previousQueue = reviewQueue!.queue
        let updatedReviewQueue = ReviewQueue(reviewQueue!, cards: previousQueue)
        
        XCTAssertEqual(updatedReviewQueue.id, reviewQueue!.id)
        XCTAssertEqual(updatedReviewQueue.getReviewableCardCount(), 2)
        XCTAssertEqual(updatedReviewQueue.queue.count, 1)
    }
    
    func testReviewCardInitialization() {
        var reviewQueue = reviewQueue!
        XCTAssertEqual(reviewQueue.getReviewableCardCount(), 3)
        XCTAssertEqual(reviewQueue.queue.count, 2)
        
        reviewQueue.reviewCard(reviewedCard: reviewQueue.currentCard!)
        XCTAssertEqual(reviewQueue.getReviewableCardCount(), 2)
        XCTAssertEqual(reviewQueue.queue.count, 1)
        
        reviewQueue.reviewCard(reviewedCard: reviewQueue.currentCard!)
        XCTAssertEqual(reviewQueue.getReviewableCardCount(), 1)
        XCTAssertEqual(reviewQueue.queue.count, 0)
        
        reviewQueue.reviewCard(reviewedCard: reviewQueue.currentCard!)
        XCTAssertEqual(reviewQueue.getReviewableCardCount(), 0)
        XCTAssertEqual(reviewQueue.queue.count, 0)
        XCTAssertEqual(reviewQueue.currentCard, nil)
    }
}
