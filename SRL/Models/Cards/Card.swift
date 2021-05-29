//
//  Card.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Card: Cardable {
    private (set) var id: UUID
    private (set) var dateCreated: Date
    private (set) var dateLastModified: Date
    
    var schedule: Schedulable
    // content ?
    
    
    init(scheduler: Schedulable) {
        id = UUID()
        dateCreated = Date()
        dateLastModified = Date()
        schedule = scheduler
    }
}
