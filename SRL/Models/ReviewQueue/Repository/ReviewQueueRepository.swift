//
//  ReviewQueueRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 15.07.21.
//

import Foundation
import Combine

class ReviewQueueRepository {
    private static var instance: ReviewQueueRepository?
    
    @Published private (set) var reviewQueues: [UUID:ReviewQueue] = [UUID:ReviewQueue]()
    
    
    
    static func getInstance() -> ReviewQueueRepository {
        if ReviewQueueRepository.instance == nil {
            ReviewQueueRepository.instance = ReviewQueueRepository()
        }
        return ReviewQueueRepository.instance!
    }
    
    private init() {}
    
    
    
    func getReviewQueue(forId id: UUID) -> ReviewQueue? {
        return getRefreshedReviewQueue(forId: id)
    }
    
    func saveReviewQueue(_ reviewQueue: ReviewQueue) {
        reviewQueues[reviewQueue.id] = reviewQueue
    }

    func deleteReviewQueue(forId id: UUID) {
        reviewQueues.removeValue(forKey: id)
    }

    func deleteAllReviewQueues() {
        reviewQueues = [UUID:ReviewQueue]()
    }

    
    
    private func getRefreshedReviewQueue(forId id: UUID) -> ReviewQueue? {
        if let reviewQueue: ReviewQueue = reviewQueues[id] {
            let refreshedReviewQueue = refreshReviewQueue(reviewQueue)
            reviewQueues[id] = refreshedReviewQueue
            return refreshedReviewQueue
        }
        return nil
    }

    private func refreshReviewQueue(_ queue: ReviewQueue) -> ReviewQueue {
        ReviewQueueAssembler().refreshReviewQueue(queue)
    }
}
