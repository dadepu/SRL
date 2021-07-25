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
    private var schedulerObserver: AnyCancellable?
    
    
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
        schedulerObserver = SchedulerRepository.getInstance().$schedulers.sink(receiveValue: updateCards(withSchedulers:))
    }
    
    
    
    func getAllSchedulers() -> [UUID:Card] {
        cards
    }

    func getCard(forId id: UUID) -> Card? {
        cards[id]
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
    


    private func saveWithUserDefaultsRepository(cards: [UUID:Card]) {
        userDefaultsRepository.saveCards(cards)
    }
    
    private func updateCards(withSchedulers schedulers: [UUID:Scheduler]) {
        let cardAssembler = CardAssembler()
        var updatedCards: [UUID:Card] = [:]
        for (_, card) in self.cards {
            if let updatedCard = cardAssembler.refreshCard(card, withSchedulers: schedulers) {
                updatedCards[updatedCard.id] = updatedCard
            }
        }
        self.cards = updatedCards
    }
}
