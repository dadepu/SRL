//
//  ReviewAction.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation


enum ReviewAction {
    case REPEAT
    case HARD
    case GOOD
    case EASY
    case CUSTOMINTERVAL(_ interval: TimeInterval)
}
