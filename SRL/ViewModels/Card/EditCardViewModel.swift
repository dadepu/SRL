//
//  EditCardViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import Foundation
import Combine

class EditCardViewModel: AbstractCardViewModel {
    @Published private (set) var card: Card
    @Published private (set) var changedDeckId: UUID?
    @Published private (set) var changedEaseFactor: Float?
    
    private var cardObserver: AnyCancellable?
    
    
    init(deck: Deck, card: Card) {
        self.card = card
        super.init(deck: deck)
        try? initializeContentFromCard(card: card)
        
        cardObserver = CardService().getModelPublisher().sink { (cards: [UUID:Card]) in
            if let card = CardService().getCard(inDictionary: cards, forId: card.id) {
                try? self.initializeContentFromCard(card: card)
            }
        }
    }
    
    
    private func initializeContentFromCard(card: Card) throws {
        switch (card.content) {
        case .DEFAULT(let defaultCard):
            super.cardType = .Default
            super.frontCardContent = defaultCard.questionContent
            super.backCardContent = defaultCard.answerContent
        default:
            throw CardTypeException.UnsupportedCardType
        }
    }
    
    func saveCardChanges() {
        if cardIsSaveable, let cardType = try? createCardType() {
            try? CardService().replaceContent(cardId: card.id, cardContent: cardType)
            if let newDeckId = changedDeckId, newDeckId != deck.id {
                try? DeckService().transferCard(fromDeckId: deck.id, toDeckId: newDeckId, cardId: card.id)
            }
            if let newEaseFactor = changedEaseFactor, newEaseFactor != card.scheduler.easeFactor {
                try? SchedulerService().changeEaseFactor(forId: card.scheduler.id, with: newEaseFactor)
            }
        }
    }
    
    func graduateScheduler() {
        try? SchedulerService().graduateScheduler(forId: card.scheduler.id)
        guard let updatedCard = try? CardService().getCard(forId: card.id) else { return }
        try? initializeContentFromCard(card: updatedCard)
    }
    
    func resetCard() {
        try? SchedulerService().resetScheduler(forId: card.scheduler.id)
        guard let updatedCard = try? CardService().getCard(forId: card.id) else { return }
        try? initializeContentFromCard(card: updatedCard)
    }
    
    func setTransferDeckId(destinationId id: UUID) {
        self.changedDeckId = id
    }
    
    func setUpdatedEaseFactor(factor: Float) {
        self.changedEaseFactor = factor
    }
}
