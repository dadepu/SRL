//
//  ReviewQueue.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct ReviewQueue {
    private (set) var deck: Deck
    private (set) var reviewQueue: Array<Cardable> = Array()
    
    var reviewableCards: Int {
        get {
            reviewQueue.count
        }
    }
    
    
    
    init(deck: Deck) {
        self.deck = deck
        refreshReviewQueue(with: deck.cards)
    }
    
    func refreshedReviewQueue(with cards: [UUID: Cardable]) -> ReviewQueue {
        var newQueue = self
        newQueue.reviewQueue = Array()
        for card in cards {
            if card.value.schedule.isDueForReview {
                newQueue.reviewQueue.append(card.value)
            }
        }
        newQueue.reviewQueue.shuffle()
        return newQueue
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
