//
//  SchedulePresetFactoryException.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

enum SchedulePresetException: Error {
    case nameConflictsDefaultName
    case defaultPresetAlreadyDefined
    case defaultPresetNotDefined
    case defaultPresetIsImmutable
}
