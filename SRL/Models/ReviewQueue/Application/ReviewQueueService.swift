//
//  ReviewQueueService.swift
//  SRL
//
//  Created by Daniel Koellgen on 13.07.21.
//

import Foundation

struct ReviewQueueService {
    private let reviewQueueRepository = ReviewQueueRepository.getInstance()
    
    func getModelPublisher() -> Published<ReviewQueue?>.Publisher {
        reviewQueueRepository.$reviewQueue
    }
    
    
    
    func getReviewQueue() throws -> ReviewQueue {
        if let reviewQueue = reviewQueueRepository.getReviewQueue() {
            return reviewQueue
        }
        throw ReviewQueueException.EntityNotFound
    }
    
    @discardableResult
    func makeReviewQueue(deckIds: [UUID], reviewType: ReviewType) -> ReviewQueue {
        let reviewQueue = makeTransientQueue(deckIds: deckIds, reviewType: reviewType)
        reviewQueueRepository.saveReviewQueue(reviewQueue)
        return reviewQueue
    }
    
    func makeTransientQueue(deckIds: [UUID], reviewType: ReviewType) -> ReviewQueue {
        let deckService = DeckService()
        var decks: [Deck] = []
        for deckId: UUID in deckIds {
            if let deck: Deck = try? deckService.getDeck(forId: deckId) {
                decks.append(deck)
            }
        }
        let reviewQueue = ReviewQueue(decks: decks, reviewType: reviewType)
        return reviewQueue
    }
    
    func resetReviewQueue() {
        reviewQueueRepository.deleteReviewQueue()
    }

    func reviewCard(cardId: UUID, reviewAction: ReviewAction) throws -> ReviewQueue {
        let reviewQueue: ReviewQueue = try getReviewQueue()
        let card: Card = try CardService().getCard(forId: cardId)
        let reviewedCard = card.reviewedCard(as: reviewAction)
        let reviewedReviewQueue = reviewQueue.reviewedCard(card: card)

        SchedulerRepository.getInstance().saveScheduler(reviewedCard.scheduler)
        CardRepository.getInstance().saveCard(reviewedCard)
        reviewQueueRepository.saveReviewQueue(reviewedReviewQueue)
        return reviewedReviewQueue
    }
}
