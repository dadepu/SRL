//
//  DeckViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

class DeckViewModel: ObservableObject {
    private var deckServiceApi: DeckApiService
    private (set) var deck: Deck
    private (set) var reviewQueue: ReviewQueue
    private var listeningToDeckServiceApiCancellable: AnyCancellable?
    
    
    
    init(_ deckApiService: DeckApiService, deck: Deck) {
        self.deckServiceApi = deckApiService
        self.deck = deck
        self.reviewQueue = ReviewQueue(deck: deck)
        listeningToDeckServiceApiCancellable = deckServiceApi.$decks.sink(receiveValue: refreshModel)
    }
    
    // set default setting
    
    
    
    
    
    
    private func refreshModel(decks: [UUID: Deck]) {
        self.deck = self.deckServiceApi.withDeck(forID: self.deck.id)!
        self.reviewQueue = self.reviewQueue.refreshedReviewQueue(with: self.deck.cards)
        self.objectWillChange.send()
    }
}
