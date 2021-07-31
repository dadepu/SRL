//
//  ExtensionTimeInterval.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import Foundation

extension TimeInterval {
    
    func getFormatted() -> String {
        if abs(self) < 60 {
            let seconds = Int(self)
            return "\(seconds)s"
        }
        if abs(self) < (60 * 60) {
            let minutes = Int((self / 60).rounded(.up))
            return "\(minutes)m"
            
        }
        if abs(self) < (60 * 60 * 24) {
            let hours = Int((self / (60 * 60)).rounded(.up))
            return "\(hours)h"
        }
        let days = Int((self / (60 * 60 * 24)).rounded(.up))
        return "\(days)d"
    }
}
