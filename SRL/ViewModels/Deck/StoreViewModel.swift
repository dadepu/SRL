//
//  StoreViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import Foundation
import Combine

class StoreViewModel: ObservableObject {
    @Published private (set) var decks: [Deck] = []
    @Published private (set) var reviewQueues: [UUID:ReviewQueue] = [:]
    
    private var deckService = DeckService()
    private var deckObserver: AnyCancellable?
    
    
    init() {
        let hashedDecks: [UUID:Deck] = deckService.getAllDecks()
        decks = getDecksOrderedByNameDesc(hashedDecks)
        reviewQueues = makeRegularReviewQueues(hashedDecks)
        
        deckObserver = deckService.getModelPublisher().sink { (decks: [UUID:Deck]) in
            self.decks = self.getDecksOrderedByNameDesc(decks)
            self.reviewQueues = self.makeRegularReviewQueues(decks)
        }
    }

    func makeDeck(name: String, presetId: UUID) {
        deckService.makeDeck(deckName: name, presetId: presetId)
    }
    
    func dropDeck(id: UUID) {
        deckService.deleteDeck(forId: id)
        decks.removeAll(where: { deck in deck.id == id })
    }

    
    
    private func getDecksOrderedByNameDesc(_ decks: [UUID:Deck]) -> [Deck] {
        return decks.map({ (_: UUID, deck: Deck) -> Deck in
                deck
            }).sorted() { (lhs:Deck, rhs:Deck) -> Bool in
                lhs.name < rhs.name
            }
    }
    
    private func makeRegularReviewQueues(_ decks: [UUID:Deck]) -> [UUID:ReviewQueue] {
        return decks.mapValues { deck in
            StoreViewModel.getDefaultReviewQueue(deck: deck)
        }
    }
    
    private static func getDefaultReviewQueue(deck: Deck) -> ReviewQueue {
        ReviewQueueService().makeTransientQueue(deckIds: [deck.id], reviewType: .REGULAR)
    }
}
