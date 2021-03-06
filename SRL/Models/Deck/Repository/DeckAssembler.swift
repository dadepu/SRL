//
//  DeckAssembler.swift
//  SRL
//
//  Created by Daniel Koellgen on 16.07.21.
//

import Foundation

struct DeckAssembler {
    
    func refreshDeck(_ deck: Deck, withCards cards: [UUID:Card]) -> Deck {
        var updatedCards = [UUID:Card]()
        for (cardId, _) in deck.cards {
            if let updatedCard = cards[cardId] {
                updatedCards[updatedCard.id] = updatedCard
            }
        }
        return Deck(deck, cards: updatedCards)
    }
    
    func refreshDeck(_ deck: Deck, withSchedulePresets presets: [UUID:SchedulePreset]) -> Deck {
        if let updatedPreset = presets[deck.schedulePreset.id] {
            return Deck(deck, schedulePreset: updatedPreset)
        } else {
            return Deck(deck, schedulePreset: SchedulePresetService().getDefaultSchedulePreset())
        }
    }
}
