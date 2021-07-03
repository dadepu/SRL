//
//  ApplicationTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation
import XCTest
@testable import SRL

class SchedulePresetPersistanceTest: XCTestCase {
    private var schedulePresetService: SchedulePresetService = SchedulePresetService()
    
    override func setUpWithError() throws {
        schedulePresetService.deleteAllSchedulePresets()
    }
    
    func testGetDefaultIfEmpty() throws {
        let preset: SchedulePreset = schedulePresetService.getDefaultSchedulePreset()
        XCTAssertTrue(preset.isDefaultPreset)
    }
    
    func testSaveAndLoadPreset() throws {
        let presetFactory = schedulePresetService.getSchedulePresetFactory()
        if let preset = try?presetFactory.newPreset(name: "Study 1") {
            schedulePresetService.saveSchedulePreset(preset)
            
            let loadedPresetAfterSave = schedulePresetService.getSchedulePreset(forId: preset.id)!
            XCTAssertEqual(loadedPresetAfterSave, preset)
            
            try?schedulePresetService.deleteSchedulePreset(forId: preset.id)
            
            let loadedPresetAfterDelete = schedulePresetService.getSchedulePreset(forId: preset.id)
            XCTAssertNil(loadedPresetAfterDelete)
            
            let loadedPresetIsDefaultInstead = schedulePresetService.getSchedulePresetOrDefault(forId: preset.id)
            XCTAssertTrue(loadedPresetIsDefaultInstead.isDefaultPreset)
        } else {
            throw SchedulePresetPersistanceTestException.presetNotCreatedWithFactory
        }
    }
    
    enum SchedulePresetPersistanceTestException: Error {
        case presetNotCreatedWithFactory
    }
}
