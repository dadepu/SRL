//
//  ReviewQueueService.swift
//  SRL
//
//  Created by Daniel Koellgen on 13.07.21.
//

import Foundation

struct ReviewQueueService {
    
    func makeTransientQueue(deckIds: [UUID], reviewType: ReviewType) -> ReviewQueue {
        let deckService = DeckService()
        var decks: [Deck] = []
        for deckId: UUID in deckIds {
            if let deck: Deck = deckService.getDeck(forId: deckId) {
                decks.append(deck)
            }
        }
        let reviewQueue = ReviewQueue(decks: decks, reviewType: reviewType)
        return reviewQueue
    }

    func reviewCard(reviewQueue: ReviewQueue, cardId: UUID, reviewAction: ReviewAction) throws -> ReviewQueue {
        let card: Card = try CardService().getCard(forId: cardId)
        let reviewedCard = card.reviewedCard(as: reviewAction)

        SchedulerRepository.getInstance().saveScheduler(reviewedCard.scheduler)
        CardRepository.getInstance().saveCard(reviewedCard)
        return reviewQueue.reviewedCard(card: card)
    }
}
