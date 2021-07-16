//
//  ReviewQueueUserDefaultsRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 15.07.21.
//

import Foundation
import Combine

struct ReviewQueueUserDefaultsRepository {
    private static let userdefaultsDeckKey = "ReviewQueue.RootAggregate"
    
    
    func loadReviewQueues() -> [UUID:ReviewQueue]? {
        let jsonData = UserDefaults.standard.data(forKey: ReviewQueueUserDefaultsRepository.userdefaultsDeckKey)
        if jsonData != nil, let decodedSchedulers = try? JSONDecoder().decode([UUID:ReviewQueue].self, from: jsonData!) {
            return decodedSchedulers
        } else {
            return nil
        }
    }

    func saveReviewQueues(_ queues: [UUID:ReviewQueue]) {
        let presetsJSON = try? JSONEncoder().encode(queues)
        UserDefaults.standard.set(presetsJSON, forKey: ReviewQueueUserDefaultsRepository.userdefaultsDeckKey)
    }

    func deleteReviewQueues() {
        UserDefaults.standard.set("", forKey: ReviewQueueUserDefaultsRepository.userdefaultsDeckKey)
    }
}
