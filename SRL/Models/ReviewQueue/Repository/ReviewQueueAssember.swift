//
//  ReviewQueueAssember.swift
//  SRL
//
//  Created by Daniel Koellgen on 16.07.21.
//

import Foundation

struct ReviewQueueAssembler {
    private let deckRepository = DeckRepository.getInstance()
    
    
    func refreshReviewQueue(_ reviewQueue: ReviewQueue) -> ReviewQueue {
        var decks = [Deck]()
        for deck in reviewQueue.decks {
            if let loadedDeck: Deck = deckRepository.getDeck(forId: deck.id) {
                decks.append(loadedDeck)
            }
        }
        return ReviewQueue(reviewQueue, decks: decks)
    }
}
