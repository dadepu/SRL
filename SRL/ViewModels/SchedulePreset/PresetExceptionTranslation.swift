//
//  SchedulePresetFactoryExceptionTranslation.swift
//  SRL
//
//  Created by Daniel Koellgen on 27.07.21.
//

import Foundation

fileprivate struct PresetTranslations {
    let ok = ""
    let emptyContent = "Input required"
    let conflictingPresetName = "Preset name conflicts default preset"
    let invalidPattern = "Invalid input pattern"
    let negativeNumber = "Negative numbers are not permitted"
}

extension SchedulePresetFactoryException.NameValidation: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .OK:
            return PresetTranslations().ok
        case .EMPTY:
            return PresetTranslations().emptyContent
        case .CONFLICTS_DEFAULT:
            return PresetTranslations().conflictingPresetName
        }
    }
}

extension SchedulePresetFactoryException.LearningStepsValidation: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .OK:
            return PresetTranslations().ok
        case .EMPTY:
            return PresetTranslations().emptyContent
        case .INVALID_PATTERN:
            return PresetTranslations().invalidPattern
        }
    }
}

extension SchedulePresetFactoryException.GraduationIntervalValidation: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .OK:
            return PresetTranslations().ok
        case .EMPTY:
            return PresetTranslations().emptyContent
        case .INVALID_PATTERN:
            return PresetTranslations().invalidPattern
        case .NEGATIVE_NUMBER:
            return PresetTranslations().negativeNumber
        }
    }
}

extension SchedulePresetFactoryException.LapseStepsValidation: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .OK:
            return PresetTranslations().ok
        case .INVALID_PATTERN:
            return PresetTranslations().invalidPattern
        }
    }
}

extension SchedulePresetFactoryException.MinimumIntervalValidation: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .OK:
            return PresetTranslations().ok
        case .EMPTY:
            return PresetTranslations().emptyContent
        case .INVALID_PATTERN:
            return PresetTranslations().invalidPattern
        case .NEGATIVE_NUMBER:
            return PresetTranslations().negativeNumber
        }
    }
}
