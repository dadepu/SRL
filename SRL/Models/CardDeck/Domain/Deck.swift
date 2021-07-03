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
    private (set) var reviewQueue: ReviewQueue = ReviewQueue()
    private (set) var schedulePreset: SchedulePreset
    
    
    
    init(name: String) {
        self.name = name
        self.schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
    }
    
    init(name: String, schedulePreset: SchedulePreset) {
        self.name = name
        self.schedulePreset = schedulePreset
    }
    
    
    
    mutating func saveCard(forId id: UUID, card: Card) {
        cards[card.id] = card
    }
    
    func savedCard(card: Card) -> Deck {
        var deck = self
        deck.cards[card.id] = card
        return deck
    }
    
    func getCard(forId id: UUID) -> Card? {
        cards[id]
    }
    
    mutating func dropCard(forId id: UUID) -> Card? {
        cards.removeValue(forKey: id)
    }
    
    func droppedCard(forId id: UUID) -> Deck {
        var deck = self
        deck.cards.removeValue(forKey: id)
        return deck
    }
    
    mutating func renameDeck(name: String) {
        self.name = name
    }
}

extension Deck: Equatable {
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        return
            lhs.id == rhs.id
    }
}
