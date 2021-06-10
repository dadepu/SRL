//
//  Card.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Card: Codable {
    private (set) var id: UUID = UUID()
    private (set) var dateCreated: Date = Date()
    private (set) var dateLastModified: Date = Date()
    private (set) var schedule: Scheduler
    
    
    init(schedule: Scheduler) {
        self.schedule = schedule
    }
    
    func scheduled(with schedule: Scheduler) -> Card {
        var card = self
        card.schedule = schedule
        card.dateLastModified = Date()
        return card
    }
}
