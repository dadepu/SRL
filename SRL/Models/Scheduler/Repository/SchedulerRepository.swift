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
    private (set) var userDefaultsRepository = SchedulerUserDefaultsRepository()
    
    @Published private (set) var schedulers: [UUID:Scheduler] = [UUID:Scheduler]()
    private var dataSaving: AnyCancellable?
    
    
    
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
    }
    
    
    
    
    func getAllSchedulers() -> [UUID:Scheduler] {
        return getAllRefreshedSchedulers()
    }
    
    func getScheduler(forId id: UUID) -> Scheduler? {
        return getRefreshedScheduler(forId: id)
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
    
    
    
    
    private func getRefreshedScheduler(forId id: UUID) -> Scheduler? {
        if let scheduler: Scheduler = schedulers[id] {
            let refreshedScheduler = refreshScheduler(scheduler)
            schedulers[id] = refreshedScheduler
            return refreshedScheduler
        }
        return nil
    }
    
    private func getAllRefreshedSchedulers() -> [UUID:Scheduler] {
        let schedulers = self.schedulers
        var refreshedSchedulers = [UUID:Scheduler]()
        for (_, value) in schedulers {
            let refreshedScheduler = refreshScheduler(value)
            refreshedSchedulers[refreshedScheduler.id] = refreshedScheduler
        }
        self.schedulers = refreshedSchedulers
        return refreshedSchedulers
    }
    
    private func refreshScheduler(_ scheduler: Scheduler) -> Scheduler {
        return SchedulerAssembler().refreshScheduler(scheduler)
    }
    
    private func saveWithUserDefaultsRepository(scheduler: [UUID:Scheduler]) {
        userDefaultsRepository.saveSchedulers(scheduler)
    }
}
