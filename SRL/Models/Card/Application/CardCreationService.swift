//
//  CardCreationService.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import Foundation

struct CardCreationService {
    private (set) var cardRepository: CardRepository
    private (set) var schedulerRepository: SchedulerRepository
    
    
    init(cardRepository: CardRepository, schedulerRepository: SchedulerRepository) {
        self.cardRepository = cardRepository
        self.schedulerRepository = schedulerRepository
    }
    
    
    func makeCard(cardType: CardType, schedulePresetId: UUID) -> Card {
        let schedulePreset = SchedulePresetService().getSchedulePresetOrDefault(forId: schedulePresetId)
        let scheduler = Scheduler(schedulePreset: schedulePreset)
        let card = Card(content: cardType, scheduler: scheduler)
        schedulerRepository.saveScheduler(scheduler)
        cardRepository.saveCard(card)
        return card
    }
}
