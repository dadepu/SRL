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

extension .NameValidation: CustomStringConvertible {
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

extension .LearningStepsValidation: CustomStringConvertible {
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

extension .GraduationIntervalValidation: CustomStringConvertible {
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

extension .LapseStepsValidation: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .OK:
            return PresetTranslations().ok
        case .INVALID_PATTERN:
            return PresetTranslations().invalidPattern
        }
    }
}

extension .MinimumIntervalValidation: CustomStringConvertible {
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
