//
//  Card.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Card: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var dateCreated: Date = Date()
    private (set) var dateLastModified: Date = Date()
    private (set) var scheduler: Scheduler
    private (set) var content: CardType
    
    
    init(content: CardType, scheduler: Scheduler) {
        self.content = content
        self.scheduler = scheduler
    }
    
    init(_ card: Card, scheduler: Scheduler) {
        self = card
        self.scheduler = scheduler
    }
    
    
    func changedContent(content: CardType) -> Card {
        var card = self
        card.content = content
        return card
    }
    
    func reviewedCard(as action: ReviewAction) -> Card {
        var card = self
        card.scheduler = scheduler.processedReviewAction(as: action)
        card.dateLastModified = Date()
        return card
    }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.id == rhs.id
    }
}
