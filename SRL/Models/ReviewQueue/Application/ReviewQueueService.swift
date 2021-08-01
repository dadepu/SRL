//
//  ReviewQueueService.swift
//  SRL
//
//  Created by Daniel Koellgen on 13.07.21.
//

import Foundation

struct ReviewQueueService {
    private let reviewQueueRepository = ReviewQueueRepository.getInstance()
    
    func getModelPublisher() -> Published<[UUID:ReviewTypes]>.Publisher {
        reviewQueueRepository.$reviewQueue
    }
    
    
    
    func getReviewQueue(deckId: UUID, type: ReviewType) throws -> ReviewQueue {
        if let reviewQueue = reviewQueueRepository.getReviewQueue(deckId: deckId, reviewType: type) {
            return reviewQueue
        }
        throw ReviewQueueException.EntityNotFound
    }
    
    @discardableResult
    func makeReviewQueue(deckId: UUID, reviewType: ReviewType) -> ReviewQueue {
        let reviewQueue = makeTransientQueue(deckId: deckId, reviewType: reviewType)
        reviewQueueRepository.saveReviewQueue(deckId: deckId, reviewType: reviewType, queue: reviewQueue)
        return reviewQueue
    }
    
    func makeTransientQueue(deckId: UUID, reviewType: ReviewType) -> ReviewQueue {
        var decks: [Deck] = []
        if let deck = try? DeckService().getDeck(forId: deckId) {
            decks.append(deck)
        }
        let reviewQueue = ReviewQueue(decks: decks, reviewType: reviewType)
        return reviewQueue
    }
    
    func resetReviewQueue() {
        reviewQueueRepository.deleteAll()
    }
    
    func resetReviewQueue(forDeckId: UUID) {
        reviewQueueRepository.delete(forDeckId: forDeckId)
    }

    func reviewCard(deckId: UUID, cardId: UUID, reviewType: ReviewType, reviewAction: ReviewAction) throws -> ReviewQueue {
        let reviewQueue: ReviewQueue = try getReviewQueue(deckId: deckId, type: reviewType)
        let card: Card = try CardService().getCard(forId: cardId)
        let reviewedCard = card.reviewedCard(as: reviewAction)
        let reviewedReviewQueue = reviewQueue.reviewedCard(card: card)
        SchedulerRepository.getInstance().saveScheduler(reviewedCard.scheduler)
        CardRepository.getInstance().saveCard(reviewedCard)
        reviewQueueRepository.saveReviewQueue(deckId: deckId, reviewType: reviewType, queue: reviewedReviewQueue)
        return reviewedReviewQueue
    }
}
