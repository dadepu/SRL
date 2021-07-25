//
//  SchedulerRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation
import Combine

class SchedulerRepository {
    private static var instance: SchedulerRepository?
    private var userDefaultsRepository = SchedulerUserDefaultsRepository()
    
    @Published private (set) var schedulers: [UUID:Scheduler] = [UUID:Scheduler]()
    
    private var dataSaving: AnyCancellable?
    private var schedulePresetObserver: AnyCancellable?
    
    
    static func getInstance() -> SchedulerRepository {
        if SchedulerRepository.instance == nil {
            SchedulerRepository.instance = SchedulerRepository()
        }
        return SchedulerRepository.instance!
    }
    
    private init() {
        if let loadedScheduler: [UUID:Scheduler] = userDefaultsRepository.loadSchedulers() {
            schedulers = loadedScheduler
        }
        dataSaving = $schedulers.sink(receiveValue: saveWithUserDefaultsRepository)
        schedulePresetObserver = SchedulePresetRepository.getInstance().$schedulePresets.sink(receiveValue: updateSchedulers(withSchedulePresets:))
    }
    
    
    
    
    func getAllSchedulers() -> [UUID:Scheduler] {
        schedulers
    }
    
    func getScheduler(forId id: UUID) -> Scheduler? {
        schedulers[id]
    }
    
    func saveScheduler(_ scheduler: Scheduler) {
        schedulers[scheduler.id] = scheduler
    }
    
    func deleteScheduler(forId id: UUID) {
        schedulers.removeValue(forKey: id)
    }
    
    func deleteAllSchedulers() {
        schedulers = [UUID:Scheduler]()
    }
    
    
    
    private func saveWithUserDefaultsRepository(scheduler: [UUID:Scheduler]) {
        userDefaultsRepository.saveSchedulers(scheduler)
    }
    
    private func updateSchedulers(withSchedulePresets schedulePresets: [UUID:SchedulePreset]) {
        let schedulerAssembler = SchedulerAssembler()
        var updatedSchedulers: [UUID:Scheduler] = [:]
        for (_, scheduler) in self.schedulers {
            let updatedScheduler = schedulerAssembler.refreshScheduler(scheduler, withSchedulePresets: schedulePresets)
            updatedSchedulers[updatedScheduler.id] = updatedScheduler
        }
        self.schedulers = updatedSchedulers
    }
}
