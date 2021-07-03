//
//  FactoringDeck.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

protocol FactoringDeck {
    func newDeck(name: String, schedulePreset: SchedulePreset?) throws -> Deck
}
