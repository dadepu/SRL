//
//  DeckApiService.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

final class DeckApiService {
    @Published private (set) var decks: [UUID: Deck] = [UUID: Deck]()
    
    
    
    func addDeck(withDeck deck: Deck) {
        decks[deck.id] = deck
    }
    
    func withDeck(forID deckID: UUID) -> Deck? {
        decks[deckID]
    }
    
    func dropDeck(forID deckID: UUID) -> Deck? {
        let deck = decks[deckID]
        decks.removeValue(forKey: deckID)
        return deck
    }
}
