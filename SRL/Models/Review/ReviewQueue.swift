//
//  ReviewQueue.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct ReviewQueue: Reviewable {
    private (set) var deck: Deck
    private (set) var reviewQueue: Array<Cardable> = Array()
    
    var reviewableCards: Int {
        get {
            reviewQueue.count
        }
    }
    var nextCard: Cardable? {
        get {
            reviewQueue.last
        }
    }
    
    
    
    init(deck: Deck) {
        self.deck = deck
        refreshReviewQueue(with: deck.cards)
    }
    
    private mutating func refreshReviewQueue(with cards: [UUID: Cardable]) {
        reviewQueue = Array()
        for card in cards {
            if card.value.schedule.isDueForReview {
                reviewQueue.append(card.value)
            }
        }
        reviewQueue.shuffle()
    }
}
