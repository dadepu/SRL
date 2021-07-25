//
//  ReviewQueueService.swift
//  SRL
//
//  Created by Daniel Koellgen on 13.07.21.
//

import Foundation

struct ReviewQueueService {
    private let reviewQueueRepository = ReviewQueueRepository.getInstance()
    
    
    func getModelPublisher() -> Published<[UUID : ReviewQueue]>.Publisher {
        reviewQueueRepository.$reviewQueues
    }
    

    
    func getReviewQueue(reviewQueueId id: UUID) throws -> ReviewQueue {
        if let reviewQueue = reviewQueueRepository.getReviewQueue(forId: id) {
            return reviewQueue
        }
        throw ReviewQueueException.EntityNotFound
    }
    
    func makeTransientQueue(decks: [Deck], reviewType: ReviewType) -> ReviewQueue {
        ReviewQueue(decks: decks, reviewType: reviewType)
    }
    
    func makeReviewQueue(deckIds: [UUID], reviewType: ReviewType) -> ReviewQueue {
        let deckService = DeckService()
        var decks: [Deck] = []
        for deckId: UUID in deckIds {
            if let deck: Deck = deckService.getDeck(forId: deckId) {
                decks.append(deck)
            }
        }
        print(decks.count)
        let reviewQueue = ReviewQueue(decks: decks, reviewType: reviewType)
        reviewQueueRepository.saveReviewQueue(reviewQueue)
        return reviewQueue
    }
    
    func reviewCard(reviewQueueId: UUID, cardId: UUID, reviewAction: ReviewAction) throws -> ReviewQueue {
        var reviewQueue: ReviewQueue = try getReviewQueue(reviewQueueId: reviewQueueId)
        let card: Card = try CardService().getCard(forId: cardId)
        
//        CardService().reviewCard(forId: cardId, action: reviewAction)
        reviewQueue.reviewCard(reviewedCard: card)
        reviewQueueRepository.saveReviewQueue(reviewQueue)
        return reviewQueue
    }
    
    func refreshReviewQueue(_ reviewQueue: ReviewQueue, withCards cards: [Card]) -> ReviewQueue {
        let refreshedReviewQueue = ReviewQueue(reviewQueue, cards: cards)
        reviewQueueRepository.saveReviewQueue(refreshedReviewQueue)
        return refreshedReviewQueue
    }
    
    func refreshReviewQueue(_ reviewQueue: ReviewQueue, withDecks decks: [Deck]) -> ReviewQueue {
        let refreshedReviewQueue = ReviewQueue(reviewQueue, decks: decks)
        reviewQueueRepository.saveReviewQueue(refreshedReviewQueue)
        return refreshedReviewQueue
    }
}
