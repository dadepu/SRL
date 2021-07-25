//
//  CreateCardViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import Foundation
import Combine

class CreateCardViewModel: AbstractCardViewModel {
    
    // TODO: for future card types it may be necessary to check the front card content as well
    func changeCardType(cardType: CardTypeMapper) {
        super.cardType = cardType
        super.backCardContent = []
    }
    
    func saveAsCard() {
        if cardIsSaveable, let cardType = try? createCardType() {
            _ = try? DeckService().makeCard(deckId: deck.id, schedulePresetId: schedulePreset.id, cardType: cardType)
        }
        super.frontCardContent = []
        super.backCardContent = []
    }
}
