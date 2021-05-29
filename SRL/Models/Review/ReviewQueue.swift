//
//  ReviewQueue.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

class ReviewQueue: Reviewable {
    private (set) var id: UUID
    private (set) var deck: Deck
    private var reviewQueue: Array<Cardable>
    private var refreshQueueCancellable: AnyCancellable?
    
    var remainingCards: Int {
        get {
            reviewQueue.count
        }
    }
    var nextCard: Cardable? {
        get {
            reviewQueue.popLast()
        }
    }
    
    
    init(deck: Deck, cards: Published<[UUID : Cardable]>.Publisher) {
        self.id = UUID()
        self.deck = deck
        self.reviewQueue = []
        self.refreshQueueCancellable = cards.sink { cards in self.refreshReviewQueue(cards: cards) }
    }
    
    private func refreshReviewQueue(cards: [UUID: Cardable]) {
        reviewQueue = Array()
        for _ in cards {
            // if card -> add to blabla
        }
        reviewQueue.shuffle()
    }
    
    static func createInstance(deck: Deck, cards: Published<[UUID : Cardable]>.Publisher) -> Reviewable {
        return ReviewQueue(deck: deck, cards: cards)
    }
}
