//
//  SchedulePresetFactoryException.swift
//  SRL
//
//  Created by Daniel Koellgen on 02.07.21.
//

import Foundation

enum SchedulePresetException: Error {
    case EntityNotFound
    case NameConflictsDefaultName
    case DefaultPresetAlreadyDefined
    case DefaultPresetNotDefined
    case DefaultPresetIsImmutable
}

