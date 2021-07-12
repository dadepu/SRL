//
//  DeckViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

class DeckViewModel: ObservableObject {
    private let cardDeckService = CardDeckService()
    private var cardDeckObserver: AnyCancellable?
    
    @Published private (set) var deck: Deck
    
    
    init(deck: Deck) {
        self.deck = deck
        cardDeckObserver = cardDeckService.getModelPublisher().sink(receiveValue: refreshDeck(decks:))
    }
    
    
    func editDeck(name: String, presetIndex: Int) {
        let presetViewModel = PresetViewModel()
        cardDeckService.editDeck(deckId: deck.id, name: name, presetId: presetViewModel.getPreset(forIndex: presetIndex)?.id)
    }
    
    func dropDeck(id: UUID) {
        cardDeckService.deleteDeck(forId: id)
    }
    
    private func refreshDeck(decks: [UUID:Deck]) {
        if let deck: Deck = cardDeckService.getDeck(inDictionary: decks, forKey: self.deck.id) {
            self.deck = deck
        } else {
            cardDeckObserver?.cancel()
        }
    }
}
