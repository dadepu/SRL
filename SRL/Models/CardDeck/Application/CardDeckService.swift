//
//  CardDeckService.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct CardDeckService {
    private let deckRepository = DeckRepository.getInstance()
    
    
    func getAllDecks() -> [UUID:Deck]? {
        deckRepository.getAllDecks()
    }
    
    func getDeck(forId id: UUID) -> Deck? {
        deckRepository.getDeck(forId: id)
    }
    
    func saveDeck(deck: Deck) {
        deckRepository.saveDeck(deck: deck)
    }
    
    func deleteDeck(forId id: UUID) {
        deckRepository.deleteDeck(forId: id)
    }
    
    func deleteAllDecks() {
        deckRepository.deleteAllDecks()
    }
}
