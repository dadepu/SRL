//
//  CardRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation
import Combine

class CardRepository {
    private static var instance: CardRepository?
    private (set) var userDefaultsRepository = CardUserDefaultsRepository()
    
    @Published private (set) var cards: [UUID:Card] = [UUID:Card]()
    private var dataSaving: AnyCancellable?
    
    
    
    static func getInstance() -> CardRepository {
        if CardRepository.instance == nil {
            CardRepository.instance = CardRepository()
        }
        return CardRepository.instance!
    }
    
    private init() {
        if let loadedCards: [UUID:Card] = userDefaultsRepository.loadCards() {
            cards = loadedCards
        }
        dataSaving = $cards.sink(receiveValue: saveWithUserDefaultsRepository)
    }
    
    
    
    
    func getAllSchedulers() -> [UUID:Card] {
        getAllRefreshedCards()
    }

    func getCard(forId id: UUID) -> Card? {
        getRefreshedCard(forId: id)
    }

    func saveCard(_ card: Card) {
        cards[card.id] = card
    }

    func deleteCard(forId id: UUID) {
        cards.removeValue(forKey: id)
    }

    func deleteAllCards() {
        cards = [UUID:Card]()
    }
    
    
    
    
    private func getRefreshedCard(forId id: UUID) -> Card? {
        if let card: Card = cards[id], let refreshedCard: Card = refreshCard(card) {
            return refreshedCard
        } else {
            return nil
        }
    }

    private func getAllRefreshedCards() -> [UUID:Card] {
        let cards = self.cards
        var refreshedCards = [UUID:Card]()
        for (_, value) in cards {
            if let refreshedCard: Card = refreshCard(value) {
                refreshedCards[refreshedCard.id] = refreshedCard
            }
        }
        return refreshedCards
    }

    private func refreshCard(_ card: Card) -> Card? {
        return CardAssembler().refreshCard(card)
    }
    
    private func saveWithUserDefaultsRepository(cards: [UUID:Card]) {
        userDefaultsRepository.saveCards(cards)
    }
}
