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
        guard let card = cardRepository.getCard(forId: id) else {
            throw CardException.EntityNotFound
        }
        return card
    }
    
    func getCard(inDictionary cards: [UUID:Card], forId id: UUID) -> Card? {
        cards[id]
    }
    
    func replaceContent(cardId id: UUID, cardContent: CardType) throws {
        let card = try getCard(forId: id)
        let updatedCard = card.replacedContent(content: cardContent)
        cardRepository.saveCard(updatedCard)
        ReviewQueueService().resetReviewQueue()
    }
}
