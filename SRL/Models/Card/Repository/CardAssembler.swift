//
//  CardAssembler.swift
//  SRL
//
//  Created by Daniel Koellgen on 16.07.21.
//

import Foundation

struct CardAssembler {
    
    func refreshCard(_ card: Card) -> Card? {
        if let updatedScheduler: Scheduler = SchedulerService().getScheduler(forId: card.scheduler.id) {
            return Card(card, scheduler: updatedScheduler)
        }
        return nil
    }
}
