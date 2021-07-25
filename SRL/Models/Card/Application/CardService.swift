//
//  CardService.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation

struct CardService {
    private let cardRepository = CardRepository.getInstance()
    private let schedulerRepository = SchedulerRepository.getInstance()
    
    
    func getModelPublisher() -> Published<[UUID : Card]>.Publisher {
        cardRepository.$cards
    }
    
    
    
    func getCard(forId id: UUID) -> Card? {
        cardRepository.getCard(forId: id)
    }
    
    func getCard(forId id: UUID) throws -> Card {
        if let card = cardRepository.getCard(forId: id) {
            return card
        }
        throw CardException.EntityNotFound
    }
    
    func getCard(inDictionary cards: [UUID:Card], forId id: UUID) -> Card? {
        cards[id]
    }
    
    func replaceCardContent(cardId id: UUID, cardContent: CardType) {
        if let card = getCard(forId: id) {
            let updatedCard = card.changedContent(content: cardContent)
            cardRepository.saveCard(updatedCard)
        }
    }
    
    func replaceScheduler(cardId id: UUID, schedulerId: UUID) {
        // TODO
    }
    
    // TODO entfernen
    func reviewCard(forId id: UUID, action: ReviewAction) {
        if let card = getCard(forId: id) {
            let reviewedCard = card.reviewedCard(as: action)
            schedulerRepository.saveScheduler(reviewedCard.scheduler)
            cardRepository.saveCard(reviewedCard)
        }
    }
}
