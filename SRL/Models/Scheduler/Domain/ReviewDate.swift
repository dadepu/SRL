//
//  ReviewDate.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct ReviewDate: Codable {
    private (set) var date: Date
    
    private init(date: Date) {
        self.date = date
    }
    
    static func makeFromCurrentDate() -> ReviewDate {
        return ReviewDate(date: Date())
    }
    
    static func makeFromInterval(interval: ReviewInterval) -> ReviewDate {
        let newDate = DateInterval(start: Date(), duration: interval.intervalSeconds).end
        return ReviewDate(date: newDate)
    }
}
