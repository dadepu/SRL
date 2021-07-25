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
    
    public func saveCardChanges() {
        if cardIsSaveable, let cardType = try? createCardType() {
            CardService().replaceCardContent(cardId: card.id, cardContent: cardType)
            CardService().replaceScheduler(cardId: card.id, schedulerId: schedulePreset.id)
        }
    }
}
