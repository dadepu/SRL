//
//  CardDeletionService.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import Foundation

struct CardDeletionService {
    private (set) var cardRepository: CardRepository
    private (set) var schedulerRepository: SchedulerRepository
    
    
    init(cardRepository: CardRepository, schedulerRepository: SchedulerRepository) {
        self.cardRepository = cardRepository
        self.schedulerRepository = schedulerRepository
    }
    
    func deleteCard(forId id: UUID) {
        if let card = CardService().getCard(forId: id) {
            schedulerRepository.deleteScheduler(forId: card.scheduler.id)
            cardRepository.deleteCard(forId: id)
        }
    }
    
    func deleteCards(forIds ids: [UUID]) {
        for id in ids {
            deleteCard(forId: id)
        }
    }
}
