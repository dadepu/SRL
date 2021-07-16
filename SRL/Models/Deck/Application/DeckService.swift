//
//  CardDeckService.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

struct DeckService {
    private let deckRepository = DeckRepository.getInstance()
    private let cardRepository = CardRepository.getInstance()
    

    func getModelPublisher() -> Published<[UUID : Deck]>.Publisher {
        deckRepository.$decks
    }
    
    
    
    func getAllDecks() -> [UUID : Deck] {
        deckRepository.getAllDecks()
    }
    
    func getDeck(forId id: UUID) -> Deck? {
        deckRepository.getDeck(forId: id)
    }

    func getDeck(inDictionary decks: [UUID : Deck], forKey key: UUID) -> Deck? {
        decks[key]
    }
    
    @discardableResult
    func makeDeck(name: String, presetId: UUID) -> Deck {
        let preset = SchedulePresetService().getSchedulePresetOrDefault(forId: presetId)
        let deck = Deck(name: name, schedulePreset: preset)
        deckRepository.saveDeck(deck: deck)
        return deck
    }
    
    func deleteDeck(forId id: UUID) {
        // delete deck
        // delete cards
        // delete scheduler
    }
    
    func renameDeck(forId id: UUID, withName name: String) {
        if let deck = getDeck(forId: id) {
            let renamedDeck = deck.renamedDeck(name: name)
            deckRepository.saveDeck(deck: renamedDeck)
        }
    }
    
    func updateSchedulePreset(forId id: UUID, withPresetId presetId: UUID) {
        if let deck = getDeck(forId: id), let preset = SchedulePresetService().getSchedulePreset(forId: presetId) {
            let updatedScheduleDeck = deck.hasSetSchedulePreset(schedulePreset: preset)
            deckRepository.saveDeck(deck: updatedScheduleDeck)
        }
    }
    
    func addCard() {
        
    }
    
    func removeCard(forDeckId deckId: UUID, withCardId cardId: UUID) {
        
    }
}
