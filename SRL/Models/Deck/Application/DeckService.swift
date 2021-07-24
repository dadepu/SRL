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
    private let schedulerRepository = SchedulerRepository.getInstance()
    

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
        let cardDeletionService = CardDeletionService(cardRepository: cardRepository, schedulerRepository: schedulerRepository)
        if let deck = getDeck(forId: id) {
            let cardIds: [UUID] = deck.cards.map { (key: UUID, value: Card) in
                key
            }
            cardDeletionService.deleteCards(forIds: cardIds)
            deckRepository.deleteDeck(forId: deck.id)
        }
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
    
    func makeCard(deckId: UUID, schedulePresetId: UUID, cardType: CardType) throws -> Card {
        if let deck = getDeck(forId: deckId) {
            let cardCreationService = CardCreationService(cardRepository: cardRepository, schedulerRepository: schedulerRepository)
            let newCard = cardCreationService.makeCard(cardType: cardType, schedulePresetId: schedulePresetId)
            let updatedDeck = deck.addedCard(card: newCard)
            deckRepository.saveDeck(deck: updatedDeck)
        }
        throw DeckException.deckNotFound
    }
    
    func deleteCard(forDeckId deckId: UUID, withCardId cardId: UUID) {
        if let deck = getDeck(forId: deckId), let card = deck.cards[cardId] {
            let cardDeletionService = CardDeletionService(cardRepository: cardRepository, schedulerRepository: schedulerRepository)
            cardDeletionService.deleteCard(forId: card.id)
            let updatedDeck = deck.removedCard(cardId: card.id)
            deckRepository.saveDeck(deck: updatedDeck)
        }
    }
}
