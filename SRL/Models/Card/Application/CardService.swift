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
    
    
    func getCard(forId id: UUID) throws -> Card {
        if let card = cardRepository.getCard(forId: id) {
            return card
        }
        throw CardException.EntityNotFound
    }
    
    func getCard(inDictionary cards: [UUID:Card], forId id: UUID) -> Card? {
        cards[id]
    }
    
    func replaceContent(cardId id: UUID, cardContent: CardType) throws {
        let card = try getCard(forId: id)
        let updatedCard = card.changedContent(content: cardContent)
        cardRepository.saveCard(updatedCard)
    }
}
