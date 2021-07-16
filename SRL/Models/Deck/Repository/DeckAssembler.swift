//
//  DeckAssembler.swift
//  SRL
//
//  Created by Daniel Koellgen on 16.07.21.
//

import Foundation

struct DeckAssembler {
    private let schedulePresetService = SchedulePresetService()
    private let cardRepository = CardRepository.getInstance()
    
    
    func refreshedDeck(_ deck: Deck) -> Deck {
        let cards = getRefreshedCards(cards: deck.cards)
        let preset = getSchedulePreset(id: deck.schedulePreset.id)
        return Deck(deck, cards: cards, schedulePreset: preset)
    }
    
    
    private func getRefreshedCards(cards: [UUID : Card]) -> [UUID : Card] {
        var loadedCards = [UUID : Card]()
        for (key, _) in cards {
            if let loadedCard: Card = cardRepository.getCard(forId: key) {
                loadedCards[loadedCard.id] = loadedCard
            }
        }
        return loadedCards
    }
    
    private func getSchedulePreset(id: UUID) -> SchedulePreset {
        schedulePresetService.getSchedulePresetOrDefault(forId: id)
    }
}
