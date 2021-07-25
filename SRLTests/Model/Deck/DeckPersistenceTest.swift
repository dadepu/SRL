//
//  DeckPersistenceTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 25.07.21.
//

import Foundation
import XCTest
@testable import SRL

class DeckPersistenceTest: XCTestCase {
    
    
    func testPrintReviewedCards() {
        let decks: [Deck] = DeckService().getAllDecks().map { key, value in value }
        
        for deck: Deck in decks {
            if deck.name == "ST2" {
                
            }
        }
    }
}
