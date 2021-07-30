//
//  SchedulerService.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation

struct SchedulerService {
    private let schedulerRepository = SchedulerRepository.getInstance()
    
    
    func getModelPublisher() -> Published<[UUID:Scheduler]>.Publisher {
        schedulerRepository.$schedulers
    }
    
    
    func getScheduler(forId id: UUID) throws -> Scheduler {
        guard let scheduler = schedulerRepository.getScheduler(forId: id) else {
            throw SchedulerException.EntityNotFound
        }
        return scheduler
    }
    
    func setPreset(forId id: UUID, withId presetId: UUID) throws {
        let preset = try SchedulePresetService().getSchedulePreset(forId: presetId)
        var scheduler = try getScheduler(forId: id)
        scheduler.setSchedulePreset(preset)
        schedulerRepository.saveScheduler(scheduler)
    }
    
    func changeEaseFactor(forId id: UUID, with factor: EaseFactor) throws {
        var scheduler = try getScheduler(forId: id)
        scheduler.replaceEaseFactor(factor)
        schedulerRepository.saveScheduler(scheduler)
    }
    
    func graduateScheduler(forId id: UUID) throws {
        let scheduler = try getScheduler(forId: id)
        let updatedScheduler = try scheduler.graduatedScheduler()
        schedulerRepository.saveScheduler(updatedScheduler)
        ReviewQueueService().resetReviewQueue()
    }
    
    func resetScheduler(forId id: UUID) throws {
        let scheduler = try getScheduler(forId: id)
        let updatedScheduler = scheduler.resettedScheduler()
        schedulerRepository.saveScheduler(updatedScheduler)
        ReviewQueueService().resetReviewQueue()
    }
}
