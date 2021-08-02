//
//  ExtensionReviewInterval.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import Foundation

extension ReviewInterval {
    
    func getFormatted() -> String {
        if abs(intervalSeconds) == 0 {
            return "-"
        }
        if abs(intervalSeconds) < 60 {
            let seconds = Int(intervalSeconds)
            return "\(seconds)s"
        }
        if abs(intervalSeconds) < (60 * 60) {
            let minutes = Int((intervalSeconds / 60).rounded(.up))
            return "\(minutes)m"
            
        }
        if abs(intervalSeconds) < (60 * 60 * 24) {
            let hours = Int((intervalSeconds / (60 * 60)).rounded(.up))
            return "\(hours)h"
        }
        let days = Int((intervalSeconds / (60 * 60 * 24)).rounded(.up))
        return "\(days)d"
    }
}

