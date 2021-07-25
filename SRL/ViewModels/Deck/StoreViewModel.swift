//
//  StoreViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import Foundation
import Combine

class StoreViewModel: ObservableObject {
    private let deckService = DeckService()
    private let cardService = CardService()
    
    private var deckObserver: AnyCancellable?
    private var cardObserver: AnyCancellable?
    private var schedulerObserver: AnyCancellable?
    
    
    @Published private (set) var decks: [Deck] = []
    private (set) var reviewQueues: [UUID:ReviewQueue] = [:]
    
    
    init() {
        let hashedDecks = deckService.getAllDecks()
        decks = getDecksInOrder(hashedDecks)
        reviewQueues = getReviewQueues(hashedDecks)
        
        deckObserver = deckService.getModelPublisher().sink(receiveValue: decksUpdatedCallback)
        
    }

    
    func makeDeck(name: String, presetId: UUID) {
        deckService.makeDeck(deckName: name, presetId: presetId)
    }
    
    func dropDeck(id: UUID) {
        deckService.deleteDeck(forId: id)
    }

    
    
    private func decksUpdatedCallback(decks: [UUID:Deck]) {
        self.decks = getDecksInOrder(decks)
        self.reviewQueues = getReviewQueues(decks)
    }
    
    private func getDecksInOrder(_ decks: [UUID:Deck]) -> [Deck] {
        return try! decks.map({ (_: UUID, deck: Deck) throws -> Deck in
            deck
        }).sorted() { (lhs:Deck, rhs:Deck) -> Bool in
            lhs.name < rhs.name
        }
    }
    
    private func getReviewQueues(_ decks: [UUID:Deck]) -> [UUID:ReviewQueue] {
        var reviewQueue = [UUID:ReviewQueue]()
        for (_, deck) in decks {
            reviewQueue[deck.id] = StoreViewModel.getDefaultReviewQueue(deck: deck)
        }
        return reviewQueue
    }
    
    private static func getDefaultReviewQueue(deck: Deck) -> ReviewQueue {
        ReviewQueueService().makeTransientQueue(decks: [deck], reviewType: .REGULAR)
    }
}
