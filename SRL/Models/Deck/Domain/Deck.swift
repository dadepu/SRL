//
//  Deck.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Deck: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var name: String
    
    private (set) var cards: [UUID: Card] = [UUID: Card]()
    private (set) var schedulePreset: SchedulePreset
    
    
    init(name: String, schedulePreset: SchedulePreset) {
        self.name = name
        self.schedulePreset = schedulePreset
    }
    
    init(_ deck: Deck, cards: [UUID:Card]) {
        self = deck
        self.cards = cards
    }
    
    init(_ deck: Deck, schedulePreset: SchedulePreset) {
        self = deck
        self.schedulePreset = schedulePreset
    }
    
    
    
    func addedCard(card: Card) -> Deck {
        var deck = self
        deck.cards[card.id] = card
        return deck
    }
    
    func removedCard(cardId id: UUID) -> Deck {
        var deck = self
        deck.cards.removeValue(forKey: id)
        return deck
    }
    
    func renamedDeck(name: String) -> Deck {
        var deck = self
        deck.name = name
        return deck
    }
    
    func hasSetSchedulePreset(schedulePreset preset: SchedulePreset) -> Deck {
        var deck = self
        deck.schedulePreset = preset
        return deck
    }
}

extension Deck: Equatable {
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        return
            lhs.id == rhs.id
    }
}
