//
//  ExtensionReviewDate.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import Foundation

extension ReviewDate {
    
    func getFormatted(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
