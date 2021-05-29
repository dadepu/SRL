//
//  Deck.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

class Deck: IdentifiableUUID {
    private (set) var id: UUID
    private (set) var name: String
    @Published private (set) var cards: [UUID: Cardable]
    
    
    init(name: String) {
        id = UUID()
        cards = [UUID: Cardable]()
        self.name = name
    }
    
    
    func addCard(card: Cardable) {
        cards[card.id] = card
    }
    
    func findCard(id: UUID) -> Cardable? {
        cards[id]
    }
    
    func dropCard(id: UUID) -> Cardable? {
        cards.removeValue(forKey: id)
    }
    
    func createReviewableQueue(f: ((Deck, Published<[UUID:Cardable]>.Publisher) -> Reviewable)) -> Reviewable {
        f(self, $cards)
    }
}
