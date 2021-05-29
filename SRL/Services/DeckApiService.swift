//
//  DeckApiService.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

final class DeckApiService {
    private (set) var decks: [UUID: Deck]
    
    init() {
        decks = [UUID: Deck]()
    }
    
    func createDeck(deckName: String) {
        let deck = Deck(name: deckName)
        decks[deck.id] = deck
    }
    
    func findDeck(deckID: UUID) -> Deck? {
        decks[deckID]
    }
    
    func removeDeck(deckID: UUID) -> Deck? {
        decks.removeValue(forKey: deckID)
    }
    
    func createReviewQueue(deck: Deck) -> Reviewable {
        deck.createReviewableQueue(f: ReviewQueue.createInstance(deck:cards:))
    }
}
