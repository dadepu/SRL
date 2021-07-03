//
//  FactoringSchedulePreset.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

protocol FactoringSchedulePreset {
    func newPreset(name: String) throws -> SchedulePreset
}
