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
    private (set) var schedule: Scheduler
    private (set) var content: CardContent
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.id == rhs.id
    }
}
