//
//  OutputRange.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct OutputRangeBuilder {
    static func makeRange<A: Comparable & Numeric>(min: A, max: A, step: A) -> [A] {
        var range: [A] = []
        var i: A = min
        while (i <= max) {
            range.append(i)
            i += step
        }
        return range
    }
}
