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
    private (set) var reviewQueue: ReviewQueue
    private (set) var schedulePreset: SchedulePreset
    
    
    
    init(name: String) {
        self.name = name
        self.schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        self.reviewQueue = ReviewQueue(cards: cards)
    }
    
    init(name: String, schedulePreset: SchedulePreset) {
        self.name = name
        self.schedulePreset = schedulePreset
        self.reviewQueue = ReviewQueue(cards: cards)
    }
    
    
    
    mutating func saveCard(card: Card) {
        cards[card.id] = card
        reviewQueue.appendCard(card: card)
    }
    
    func savedCard(card: Card) -> Deck {
        var deck = self
        deck.cards[card.id] = card
        deck.reviewQueue.appendCard(card: card)
        return deck
    }
    
    func getCard(forId id: UUID) -> Card? {
        cards[id]
    }
    
    mutating func deleteCard(forId id: UUID) -> Card? {
        reviewQueue.rebuildQueue(cards: cards)
        return cards.removeValue(forKey: id)
    }
    
    func deletedCard(forId id: UUID) -> Deck {
        var deck = self
        deck.reviewQueue.rebuildQueue(cards: deck.cards)
        deck.cards.removeValue(forKey: id)
        return deck
    }
    
    mutating func renameDeck(name: String) {
        self.name = name
    }
    
    mutating func changeSchedulePreset(forPresetId id: UUID) {
        self.schedulePreset = SchedulePresetService().getSchedulePresetOrDefault(forId: id)
    }
    
    mutating func rebuildQueue() {
        reviewQueue.rebuildQueue(cards: cards)
    }
    
    func rebuildedQueue() -> Deck {
        var deck = self
        deck.reviewQueue.rebuildQueue(cards: deck.cards)
        return deck
    }
}

extension Deck: Equatable {
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        return
            lhs.id == rhs.id
    }
}
