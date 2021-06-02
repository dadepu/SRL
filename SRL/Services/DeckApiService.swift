//
//  DeckApiService.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

final class DeckApiService {
    @Published private (set) var decks: [UUID: Deck] = [UUID: Deck]()
    
    
    
    func setDeck(with deck: Deck) {
        decks[deck.id] = deck
    }
    
    func withDeck(forID deckID: UUID) -> Deck? {
        decks[deckID]
    }
    
    @discardableResult
    func dropDeck(forID deckID: UUID) -> Deck? {
        decks.removeValue(forKey: deckID)
    }
}
