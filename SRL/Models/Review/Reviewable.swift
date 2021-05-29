//
//  Reviewable.swift
//  SRL
//
//  Created by Daniel Koellgen on 29.05.21.
//

import Foundation

protocol Reviewable: IdentifiableUUID {
    var deck: Deck { get }
    var remainingCards: Int { get }
    var nextCard: Cardable? { get }
}
