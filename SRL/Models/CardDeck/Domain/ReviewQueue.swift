//
//  ReviewQueue.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct ReviewQueue: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var queue: Array<Card> = Array()
    
    var reviewableCardCount: Int {
        get {
            queue.count
        }
    }
    
    
    init(cards: [UUID:Card]) {
        rebuildQueue(cards: cards)
    }
    
    
    
    mutating func appendCard(card: Card) {
        if !queue.contains(card), card.schedule.isDueForReview {
            queue.append(card)
        }
    }
    
    mutating func rebuildQueue(cards: [UUID:Card]) {
        var queue = [Card]()
        for card in cards {
            if card.value.schedule.isDueForReview {
                queue.append(card.value)
            }
        }
        queue.shuffle()
        self.queue = queue
    }
}
