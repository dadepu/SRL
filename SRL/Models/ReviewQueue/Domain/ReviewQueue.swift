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
    private (set) var currentCard: Card?

    
    init(decks: [Deck], reviewType: ReviewType) {
        self.decks = decks
        self.reviewType = reviewType
        refreshCardsFromDeck(decks: decks)
    }
    
    init(_ reviewQueue: ReviewQueue, decks: [Deck]) {
        self = reviewQueue
        self.decks = decks
        refreshCardsFromDeck(decks: decks)
    }
    
    init(_ reviewQueue: ReviewQueue, cards: [Card]) {
        self = reviewQueue
        refreshCards(refreshedCards: cards)
    }

    
    
    func getReviewableCardCount() -> Int {
        var cardCount: Int = 0
        if currentCard != nil {
            cardCount += 1
        }
        return cardCount + queue.count
    }
    
    mutating func reviewCard(reviewedCard: Card) {
        queue.removeAll { card in card.id == reviewedCard.id }
        if currentCard != nil && currentCard!.id == reviewedCard.id {
            replaceCurrentCard(shuffledQueue: queue)
        }
    }
    
    
    
    private mutating func replaceCurrentCard(shuffledQueue: [Card]) {
        var shuffledQueue = shuffledQueue
        if let card = shuffledQueue.popLast() {
            self.currentCard = card
        } else {
            self.currentCard = nil
        }
        self.queue = shuffledQueue
    }
    
    private mutating func refreshCardsFromDeck(decks: [Deck]) {
        var newQueue = [Card]()
        for deck in decks {
            newQueue += fetchCards(deck: deck)
        }
        let shuffledQueue = shuffleQueue(queue: newQueue)
        self.decks = decks
        replaceCurrentCard(shuffledQueue: shuffledQueue)
    }

    private mutating func refreshCards(refreshedCards: [Card]) {
        let refreshedQueue: [Card] = queue.filter { card in
            refreshedCards.contains { refreshedCard in
                refreshedCard.id == card.id
            }
        }
        if currentCard != nil, let newCurrentCard = refreshedCards.first(where: { card in card.id == currentCard!.id }) {
            currentCard = newCurrentCard
        } else {
            replaceCurrentCard(shuffledQueue: refreshedQueue)
        }
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
            (scheduler.remainingReviewInterval - Double(days * 24 * 60 * 60)) < 0
        }
        case .ALLCARDS: return { _ in
            true
        }
        }
    }
}
