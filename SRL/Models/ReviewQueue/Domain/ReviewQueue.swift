//
//  ReviewQueue.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct ReviewQueue: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var decks: [Deck] = Array()
    private (set) var queue: [Card] = Array()
    private (set) var reviewType: ReviewType
    private (set) var previousCard: Card?

    
    init(decks: [Deck], reviewType: ReviewType) {
        self.decks = decks
        self.reviewType = reviewType
        refreshQueue(decks: decks)
    }
    
    init(_ reviewQueue: ReviewQueue, decks: [Deck]) {
        self = reviewQueue
        self.decks = decks
        refreshQueue(decks: decks)
    }

    
    
    func countReviewableCards() -> Int {
        queue.count
    }
    
    func getPreviousCard() -> Card? {
        previousCard
    }
    
    mutating func getNextCard() -> Card? {
        queue.last
    }
    
    @discardableResult
    mutating func popNextCard() -> Card? {
        if let card: Card = queue.popLast() {
            previousCard = card
            return card
        }
        return nil
    }
    
    
    mutating
    private func refreshQueue(decks: [Deck]) {
        var newQueue = [Card]()
        for deck in decks {
            newQueue += fetchCards(deck: deck)
        }
        self.queue = shuffleQueue(queue: newQueue)
        self.decks = decks
    }
    
    
    
    private func fetchCards(deck: Deck) -> [Card] {
        var cards = [Card]()
        let predicate: (Scheduler) -> Bool = getFilterPredicate(reviewType: self.reviewType)
        for (_, card) in deck.cards {
            if predicate(card.scheduler) {
                cards.append(card)
            }
        }
        return cards
    }
    
    private func shuffleQueue(queue: [Card]) -> [Card] {
        queue.shuffled()
    }
    
    private func getFilterPredicate(reviewType type: ReviewType) -> (Scheduler) -> Bool {
        switch type {
        case .REGULAR: return { (scheduler: Scheduler) in
            scheduler.isDueForReview
        }
        case .LEARNING: return { (scheduler: Scheduler) in
            scheduler.learningState == .LEARNING
        }
        case .LAPSING: return { (scheduler: Scheduler) in
            scheduler.learningState == .LAPSE
        }
        case .LOCKAHEAD(let days): return { (scheduler: Scheduler) in
            (scheduler.remainingReviewInterval - Double(days)) < 0 // TODO!!
        }
        case .ALLCARDS: return { _ in
            true
        }
        }
    }
}
