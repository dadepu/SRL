//
//  DeckViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

class DeckViewModel: ObservableObject {
    @Published private (set) var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
}
