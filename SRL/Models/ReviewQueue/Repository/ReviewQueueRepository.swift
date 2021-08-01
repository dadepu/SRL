//
//  ReviewQueueRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 26.07.21.
//

import Foundation
import Combine

class ReviewQueueRepository {
    private static var instance: ReviewQueueRepository?
    
    @Published private (set) var reviewQueue: [UUID:ReviewTypes] = [:]
    
    
    static func getInstance() -> ReviewQueueRepository {
        if ReviewQueueRepository.instance == nil {
            ReviewQueueRepository.instance = ReviewQueueRepository()
        }
        return ReviewQueueRepository.instance!
    }
    
    private init() {}
    
    
    
    
    func getReviewQueue(deckId: UUID, reviewType: ReviewType) -> ReviewQueue? {
        reviewQueue[deckId]?.getQueue(type: reviewType)
    }
    
    func saveReviewQueue(deckId: UUID, reviewType: ReviewType, queue: ReviewQueue) {
        guard let currentReviewTypes = reviewQueue[deckId] else {
            let newReviewTypes = ReviewTypes().hasSetQueue(type: reviewType, queue: queue)
            reviewQueue[deckId] = newReviewTypes
            return
        }
        let updatedReviewTypes = currentReviewTypes.hasSetQueue(type: reviewType, queue: queue)
        reviewQueue[deckId] = updatedReviewTypes
    }
    
    func delete(forDeckId id: UUID) {
        reviewQueue.removeValue(forKey: id)
    }
    
    func deleteAll() {
        reviewQueue = [:]
    }
}
