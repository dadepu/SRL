//
//  StoreViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import Foundation
import Combine

class StoreViewModel: ObservableObject {
    private let cardDeckService = CardDeckService()
    private var cardDeckObserver: AnyCancellable?
    
    var decks: Array<Deck> {
        get {
            let decks: [UUID:Deck] = cardDeckService.getAllDecks()
            var deckArray: [Deck] = []
            for (_, value) in decks {
                deckArray.append(value)
            }
            return deckArray.sorted() { (lhs:Deck, rhs:Deck) -> Bool in
                lhs.name < rhs.name
            }
        }
    }
    
    
    init() {
        cardDeckObserver = cardDeckService.getModelPublisher().sink(receiveValue: publishChange(_:))
    }

    
    func makeDeck(name: String, presetId: UUID) throws {
        let deckFactory = cardDeckService.getDeckFactory()
        let deck = try deckFactory.newDeck(name: name, schedulePreset: nil)
        cardDeckService.saveDeck(deck: deck)
    }
    
    func dropDeck(id: UUID) {
        cardDeckService.deleteDeck(forId: id)
    }

    private func publishChange(_: Any) {
        self.objectWillChange.send()
    }
}
