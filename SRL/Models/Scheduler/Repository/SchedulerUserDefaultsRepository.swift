//
//  ScheduleUserDefaultsRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation
import Combine

struct SchedulerUserDefaultsRepository {
    private static let userdefaultsDeckKey = "Scheduler.RootAggregate"
    
    
    func loadSchedulers() -> [UUID:Scheduler]? {
        let jsonData = UserDefaults.standard.data(forKey: SchedulerUserDefaultsRepository.userdefaultsDeckKey)
        if jsonData != nil, let decodedSchedulers = try? JSONDecoder().decode([UUID:Scheduler].self, from: jsonData!) {
            return decodedSchedulers
        } else {
            return nil
        }
    }

    func saveSchedulers(_ presets: [UUID:Scheduler]) {
        let presetsJSON = try? JSONEncoder().encode(presets)
        UserDefaults.standard.set(presetsJSON, forKey: SchedulerUserDefaultsRepository.userdefaultsDeckKey)
    }

    func deleteSchedulers() {
        UserDefaults.standard.set("", forKey: SchedulerUserDefaultsRepository.userdefaultsDeckKey)
    }
}
