//
//  CreateCardViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import Foundation
import Combine

class CreateCardViewModel: AbstractCardViewModel {
    
    func changeCardType(cardType: CardTypeMapper) {
        super.cardType = cardType
        super.backCardContent = []
    }
    
    func saveAsCard() {
        if cardIsSaveable, let cardType = try? createCardType() {
            let _ = try? DeckService().makeCard(deckId: deck.id, schedulePresetId: schedulePreset.id, cardType: cardType)
        }
        resetCardContent()
    }
    
    private func resetCardContent() {
        super.frontCardContent = []
        super.backCardContent = []
    }
}
