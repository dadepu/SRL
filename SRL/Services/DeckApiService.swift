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
        
    }
    
    func findDeck(deckID: UUID) {
        
    }
    
    func findDeck(deck: Deck) {
        
    }
    
    func removeDeck(deckID: UUID) {
        
    }
}
