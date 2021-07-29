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
    @Published private (set) var cardSorting: (Card, Card) -> Bool = DeckViewModel.sortByDatedCreatedDesc()
    
    private let deckService = DeckService()
    private var deckObserver: AnyCancellable?


    init(deck: Deck) {
        self.deck = deck
        self.reviewQueue = DeckViewModel.getDefaultReviewQueue(deck: deck)
        initializeSortedCards(cards: deck.cards, sortOrder: cardSorting)
        
        deckObserver = deckService.getModelPublisher().sink { decks in
            guard let updatedDeck  = self.deckService.getDeck(inDictionary: decks, forKey: self.deck.id) else {
                self.deckObserver?.cancel()
                return
            }
            self.deck = updatedDeck
            self.initializeSortedCards(cards: updatedDeck.cards, sortOrder: self.cardSorting)
            self.reviewQueue = DeckViewModel.getDefaultReviewQueue(deck: updatedDeck)
        }
    }


    func initializeSortedCards(cards: [UUID:Card], sortOrder: (Card, Card) -> Bool) {
        orderedCards = cards.map { (key: UUID, value: Card) in value }.sorted(by: sortOrder)
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
        indexSet.map { (index: Int) in
            self.orderedCards[index]
        }.forEach { (card: Card) in
            orderedCards.removeAll { currentCard in currentCard.id == card.id }
            deckService.deleteCard(forDeckId: deck.id, withCardId: card.id)
        }
    }
    
    private static func getDefaultReviewQueue(deck: Deck) -> ReviewQueue {
        ReviewQueueService().makeTransientQueue(deckIds: [deck.id], reviewType: .REGULAR)
    }
    
    private static func sortByDatedCreatedDesc() -> (Card, Card) -> Bool {
        { (lhs, rhs) in lhs.dateCreated > rhs.dateCreated }
    }
}
