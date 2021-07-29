//
//  InputValidation.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

protocol InputValidation {
    static func validateRegEx(input: String, pattern: () -> String) -> Bool
    static func validateRange<A: Comparable>(value: A, min: A?, max: A?) -> Bool
}

extension InputValidation {
    static func validateRegEx(input: String, pattern: () -> String) -> Bool {
        let range = NSRange(location: 0, length: input.count)
        let regex = try! NSRegularExpression(pattern: pattern())
        guard let result = regex.firstMatch(in: input, options: [], range: range), result.range.length == range.length else {
            return false
        }
        return true
    }
    
    static func validateRange<A: Comparable>(value: A, min: A?, max: A?) -> Bool {
        if let minimum = min {
            guard minimum <= value else {
                return false
            }
        }
        if let maximum = max {
            guard value <= maximum else {
                return false
            }
        }
        return true
    }
}
