//
//  Deck.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Deck: Identifiable {
    private (set) var id: UUID = UUID()
    private (set) var name: String
    private (set) var cards: [UUID: Cardable] = [UUID: Cardable]()
    
    
    
    func addedCard(card: Cardable) -> Deck {
        var deck = self
        deck.cards[card.id] = card
        return deck
    }
    
    func withCard(forId id: UUID) -> Cardable? {
        cards[id]
    }
    
    mutating func dropCard(forId id: UUID) -> Cardable? {
        cards.removeValue(forKey: id)
    }
    
    func droppedCard(forId id: UUID) -> Deck {
        var deck = self
        deck.cards.removeValue(forKey: id)
        return deck
    }
    
    func renamedDeck(name: String) -> Deck {
        var deck = self
        deck.name = name
        return deck
    }
}
