//
//  CardDeckService.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct CardDeckService {
    private let deckRepository = DeckRepository.getInstance()
    

    func getModelPublisher() -> Published<[UUID:Deck]>.Publisher {
        deckRepository.$decks
    }
    
    func getAllDecks() -> [UUID:Deck] {
        deckRepository.getAllDecks()
    }
    
    func getDeck(forId id: UUID) -> Deck? {
        deckRepository.getDeck(forId: id)
    }
    
    func getDeck(forCardId id: UUID) -> Deck? {
        // TODO
        return nil
    }
    
    func saveDeck(deck: Deck) {
        deckRepository.saveDeck(deck: deck)
    }
    
    func deleteDeck(forId id: UUID) {
        deckRepository.deleteDeck(forId: id)
    }
    
    func deleteAllDecks() {
        deckRepository.deleteAllDecks()
    }
    
    func addCard(deckId: UUID, card: Card) {
        // TODO
    }
    
    func dropCard(deckId: UUID, cardId: UUID) {
        // TODO
    }
    
    func editDeck(deckId: UUID, name: String, presetId: UUID?) {
        if var deck: Deck = getDeck(forId: deckId) {
            deck.renameDeck(name: name)
            if presetId != nil {
                deck.changeSchedulePreset(forPresetId: presetId!)
            }
            saveDeck(deck: deck)
        }
    }
    
    func refreshSchedulePresets() {
        // TODO 
    }
    
    func getDeckFactory() -> FactoringDeck {
        return DeckFactory()
    }
}
