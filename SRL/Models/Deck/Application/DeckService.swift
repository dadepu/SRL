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
    

    func getModelPublisher() -> Published<[UUID:Deck]>.Publisher {
        deckRepository.$decks
    }
    
    
    
    func getAllDecks() -> [UUID:Deck] {
        deckRepository.getAllDecks()
    }
    
    func getDeck(forId id: UUID) throws -> Deck {
        if let deck = deckRepository.getDeck(forId: id) {
            return deck
        }
        throw DeckException.EntityNotFound
    }

    func getDeck(inDictionary decks: [UUID:Deck], forKey key: UUID) -> Deck? {
        decks[key]
    }
    
    @discardableResult
    func makeDeck(deckName: String, presetId: UUID) -> Deck {
        let preset = SchedulePresetService().getSchedulePresetOrDefault(forId: presetId)
        let newDeck = Deck(name: deckName, schedulePreset: preset)
        deckRepository.saveDeck(deck: newDeck)
        return newDeck
    }
    
    func deleteDeck(forId id: UUID) {
        let cardDeletionService = CardDeletionService(cardRepository: cardRepository, schedulerRepository: schedulerRepository)
        if let deck = try? getDeck(forId: id) {
            cardDeletionService.deleteCards(forIds: deck.cards.map { key, value in key })
            deckRepository.deleteDeck(forId: deck.id)
            ReviewQueueService().resetReviewQueue(forDeckId: id)
        }
    }
    
    func renameDeck(forId id: UUID, withName name: String) {
        if let deck = try? getDeck(forId: id) {
            let renamedDeck = deck.renamedDeck(name: name)
            deckRepository.saveDeck(deck: renamedDeck)
        }
    }
    
    func updateSchedulePreset(forId id: UUID, withPresetId presetId: UUID) {
        if let deck = try? getDeck(forId: id), let preset = try? SchedulePresetService().getSchedulePreset(forId: presetId) {
            let updatedScheduleDeck = deck.hasSetSchedulePreset(schedulePreset: preset)
            deckRepository.saveDeck(deck: updatedScheduleDeck)
        }
    }
    
    func makeCard(deckId: UUID, schedulePresetId: UUID, cardType: CardType) throws -> Card {
        if let deck = try? getDeck(forId: deckId) {
            let cardCreationService = CardCreationService(cardRepository: cardRepository, schedulerRepository: schedulerRepository)
            let newPersistentCard = cardCreationService.makeCard(cardType: cardType, schedulePresetId: schedulePresetId)
            let updatedDeck = deck.addedCard(card: newPersistentCard)
            deckRepository.saveDeck(deck: updatedDeck)
            ReviewQueueService().resetReviewQueue(forDeckId: deckId)
        }
        throw DeckException.EntityNotFound
    }
    
    func deleteCard(forDeckId deckId: UUID, withCardId cardId: UUID) {
        if let deck = try? getDeck(forId: deckId), let card = deck.cards[cardId] {
            let cardDeletionService = CardDeletionService(cardRepository: cardRepository, schedulerRepository: schedulerRepository)
            cardDeletionService.deleteCard(forId: card.id)
            let updatedDeck = deck.removedCard(cardId: card.id)
            deckRepository.saveDeck(deck: updatedDeck)
            ReviewQueueService().resetReviewQueue()
        }
    }
    
    func transferCard(fromDeckId: UUID, toDeckId: UUID, cardId: UUID) throws {
        let sourceDeck = try getDeck(forId: fromDeckId)
        let destDeck = try getDeck(forId: toDeckId)
        let card = try CardService().getCard(forId: cardId)
        let updatedDecks: Deck.TransferCardData = try sourceDeck.transferedCard(newDeck: destDeck, card: card)
        deckRepository.saveDeck(deck: updatedDecks.fromDeck)
        deckRepository.saveDeck(deck: updatedDecks.toDeck)
        ReviewQueueService().resetReviewQueue()
    }
}
