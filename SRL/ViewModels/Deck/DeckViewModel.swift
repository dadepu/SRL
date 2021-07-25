//
//  DeckViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

class DeckViewModel: ObservableObject {
    @Published private (set) var deck: Deck
    @Published private (set) var reviewQueue: ReviewQueue
    @Published private (set) var orderedCards: [Card] = []
    
    private let deckService = DeckService()
    private var deckObserver: AnyCancellable?


    init(deck: Deck) {
        self.deck = deck
        self.reviewQueue = DeckViewModel.getDefaultReviewQueue(deck: deck)
        initializeSortedCards(sort: DeckViewModel.sortByDateCardCreatedNewToOld)
        
        deckObserver = deckService.getModelPublisher().sink { decks in
            if let updatedDeck  = self.deckService.getDeck(inDictionary: decks, forKey: self.deck.id) {
                self.deck = updatedDeck
                self.reviewQueue = DeckViewModel.getDefaultReviewQueue(deck: updatedDeck)
            } else {
                self.deckObserver?.cancel()
            }
        }
    }


    func initializeSortedCards(sort: (Card, Card) -> Bool) {
        orderedCards = deck.cards.map { (key: UUID, value: Card) in
            value
        }.sorted(by: sort)
    }
    
    func editDeck(name: String, presetId: UUID) {
        if deck.name != name {
            deckService.renameDeck(forId: deck.id, withName: name)
        }
        if deck.schedulePreset.id != presetId {
            deckService.updateSchedulePreset(forId: deck.id, withPresetId: presetId)
        }
    }

    func dropDeck(id: UUID) {
        deckService.deleteDeck(forId: id)
    }
    
    func deleteCards(indexSet: IndexSet) {
        for index in indexSet {
            deckService.deleteCard(forDeckId: deck.id, withCardId: self.orderedCards[index].id)
            orderedCards.remove(at: index)
        }
    }

    
    private static func getDefaultReviewQueue(deck: Deck) -> ReviewQueue {
        ReviewQueueService().makeTransientQueue(deckIds: [deck.id], reviewType: .REGULAR)
    }
    
    static func sortByDateCardCreatedNewToOld(lhs: Card, rhs: Card) -> Bool {
        lhs.dateCreated > rhs.dateCreated
    }
}
