//
//  CardDeckRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation
import Combine

class DeckRepository {
    private static var instance: DeckRepository?
    private (set) var userDefaultsRepository = DeckUserDefaultsRepository()
    
    @Published private (set) var decks: [UUID:Deck] = [UUID:Deck]()
    
    private var dataSaving: AnyCancellable?
    private var cardObserver: AnyCancellable?
    private var schedulePresetObserver: AnyCancellable?
    
    
    static func getInstance() -> DeckRepository {
        if DeckRepository.instance == nil {
            DeckRepository.instance = DeckRepository()
        }
        return DeckRepository.instance!
    }
    
    private init() {
        if let decks: [UUID:Deck] = userDefaultsRepository.loadDecks() {
            self.decks = decks
        }
        dataSaving = self.$decks.sink(receiveValue: saveWithUserDefaultsRepository)
        cardObserver = CardRepository.getInstance().$cards.sink(receiveValue: updateDecks(withCards:))
    }
    
    
    
    func getAllDecks() -> [UUID:Deck] {
        decks
    }
    
    func getDeck(forId id: UUID) -> Deck? {
        decks[id]
    }
    
    func saveDeck(deck: Deck) {
        decks[deck.id] = deck
    }
    
    func deleteDeck(forId id: UUID) {
        decks.removeValue(forKey: id)
    }
    
    func deleteAllDecks() {
        decks = [UUID:Deck]()
    }
    
    
    
    private func saveWithUserDefaultsRepository(decks: [UUID:Deck]) {
        userDefaultsRepository.saveDecks(decks)
    }
    
    private func updateDecks(withCards cards: [UUID:Card]) {
        let deckAssembler = DeckAssembler()
        var updatedDecks: [UUID:Deck] = [:]
        for (_, deck) in self.decks {
            let updatedDeck = deckAssembler.refreshDeck(deck, withCards: cards)
            updatedDecks[updatedDeck.id] = updatedDeck
        }
        self.decks = updatedDecks
    }
}
