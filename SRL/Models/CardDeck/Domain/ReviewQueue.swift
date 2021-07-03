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
    private (set) var history: ReviewHistory = ReviewHistory()
    
    var reviewableCards: Int {
        get {
            queue.count
        }
    }
}
