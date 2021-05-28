//
//  Deck.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation


struct Deck: Identifiable {
    private (set) var id: UUID
    private (set) var cards: [UUID: Cardable]
    private (set) var name: String
    
    init(name: String) {
        id = UUID()
        cards = [UUID: Cardable]()
        self.name = name
    }
    
    init(name: String, cards: [UUID: Cardable]) {
        id = UUID()
        self.cards = cards
        self.name = name
    }
    
    mutating func addCard(newCard: Cardable) {
        
    }
    
    mutating func removeCard(card: Cardable) {
        
    }
    
    mutating func removeCard(cardID: UUID) {
        
    }
    
    func findCard (card: Cardable) -> Cardable? {
        nil
    }
    
    func findCard(cardID: UUID) -> Cardable? {
        nil
    }
}
