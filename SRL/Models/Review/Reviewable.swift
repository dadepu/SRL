//
//  Reviewable.swift
//  SRL
//
//  Created by Daniel Koellgen on 29.05.21.
//

import Foundation

protocol Reviewable {
    var deck: Deck { get }
    var reviewableCards: Int { get }
    var nextCard: Cardable? { get }
}
