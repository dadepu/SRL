//
//  Card.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

struct Card: Cardable {
    private (set) var id: UUID
                  var schedule: Schedulable
    
    private (set) var dateCreated: DateComponents
    private (set) var dateLastModified: DateComponents
    
    // front side
    // back side

    init(schedule: Schedulable) {
        id = UUID()
        self.schedule = schedule
        dateCreated = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current)
        dateLastModified = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current)
    }
}
