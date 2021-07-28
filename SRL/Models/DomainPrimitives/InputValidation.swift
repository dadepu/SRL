//
//  InputValidation.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

protocol InputValidation {
    static func validateRegEx(input: String, pattern: () -> String) -> Bool
    static func validateInsideRange<A: Comparable>(value: A, min: A?, max: A?) -> Bool
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
    
    static func validateInsideRange<A: Comparable>(value: A, min: A?, max: A?) -> Bool {
        guard let minimum = min, minimum <= value else {
            return false
        }
        guard let maximum = max, value <= maximum else {
            return false
        }
        return true
    }
}
