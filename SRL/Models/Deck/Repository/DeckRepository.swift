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
    }
    
    
    
    
    func getAllDecks() -> [UUID:Deck] {
        getAllRefreshedDecks()
    }
    
    func getDeck(forId id: UUID) -> Deck? {
        getRefreshedDeck(forId: id)
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
    
    
    
    
    private func getRefreshedDeck(forId id: UUID) -> Deck? {
        if let deck: Deck = decks[id], let refreshedDeck: Deck = refreshedDeck(deck) {
            decks[id] = refreshedDeck
            return refreshedDeck
        } else {
            deleteDeck(forId: id)
            return nil
        }
    }

    private func getAllRefreshedDecks() -> [UUID:Deck] {
        let decks = self.decks
        var refreshedDecks = [UUID:Deck]()
        for (_, value) in decks {
            if let refreshedDeck: Deck = refreshedDeck(value) {
                refreshedDecks[refreshedDeck.id] = refreshedDeck
            }
        }
        self.decks = refreshedDecks
        return refreshedDecks
    }

    private func refreshedDeck(_ deck: Deck) -> Deck? {
        DeckAssembler().refreshedDeck(deck)
    }
    
    private func saveWithUserDefaultsRepository(decks: [UUID:Deck]) {
        userDefaultsRepository.saveDecks(decks)
    }
}
