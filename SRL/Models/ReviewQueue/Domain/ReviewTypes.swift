//
//  ReviewTypes.swift
//  SRL
//
//  Created by Daniel Koellgen on 01.08.21.
//

import Foundation

struct ReviewTypes: Codable {
    private (set) var regular: ReviewQueue?
    private (set) var learning: ReviewQueue?
    private (set) var lapsing: ReviewQueue?
    private (set) var all: ReviewQueue?
    private (set) var lookahead: ReviewQueue?
    
    mutating func setQueue(type: ReviewType, queue: ReviewQueue?) {
        switch (type) {
        case .REGULAR:
            regular = queue
        case .LEARNING:
            learning = queue
        case .LAPSING:
            lapsing = queue
        case .ALLCARDS:
            all = queue
        case .LOCKAHEAD(_):
            lookahead = queue
        }
    }
    
    func hasSetQueue(type: ReviewType, queue: ReviewQueue?) -> ReviewTypes {
        var updated = self
        updated.setQueue(type: type, queue: queue)
        return updated
    }
    
    func getQueue(type: ReviewType) -> ReviewQueue? {
        switch (type) {
        case .REGULAR:
            return regular
        case .LEARNING:
            return learning
        case .LAPSING:
            return lapsing
        case .ALLCARDS:
            return all
        case .LOCKAHEAD(_):
            return lookahead
        }
    }
}
