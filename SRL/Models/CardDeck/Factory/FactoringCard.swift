//
//  FactoringCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

protocol FactoringCard {
    func newCard(content: CardContent, schedule: SchedulePreset?) throws -> Card
}
