//
//  CreateCardViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import Foundation
import Combine

class CreateCardViewModel: AbstractCardViewModel {
    @Published private (set) var cardIsSaveable: Bool = false
    
    private var frontContentObserver: AnyCancellable?
    private var backContentObserver: AnyCancellable?
    
    
    override init(deck: Deck) {
        super.init(deck: deck)
        self.frontContentObserver = super.$frontCardContent.sink { (front: [CardContentTypeContainer]) in
            self.cardIsSaveable = self.validateCardIsSaveable(front: front, back: super.backCardContent)
        }
        self.backContentObserver = super.$backCardContent.sink { (back: [CardContentTypeContainer]) in
            self.cardIsSaveable = self.validateCardIsSaveable(front: super.frontCardContent, back: back)
        }
    }
    
    
    func changeCardType(cardType: CardTypeMapper) {
        super.cardType = cardType
        super.backCardContent = []
    }
    
    func addFrontContent(_ content: CardContentType) {
        frontCardContent.append(CardContentTypeContainer(content))
    }
    
    func addBackContent(_ content: CardContentType) {
        backCardContent.append(CardContentTypeContainer(content))
    }
    
    func saveAsCard() {
        if cardIsSaveable, let cardType = try? createCardType() {
            let _ = try? DeckService().makeCard(deckId: deck.id, schedulePresetId: schedulePreset.id, cardType: cardType)
        }
        resetCardContent()
    }
    
    private func validateCardIsSaveable(front: [CardContentTypeContainer], back: [CardContentTypeContainer]) -> Bool {
        front.count > 0 && back.count > 0
    }
    
    private func resetCardContent() {
        super.frontCardContent = []
        super.backCardContent = []
    }
}
