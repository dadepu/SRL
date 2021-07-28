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
    
    @Published private (set) var reviewQueue: ReviewQueue?
    
    
    static func getInstance() -> ReviewQueueRepository {
        if ReviewQueueRepository.instance == nil {
            ReviewQueueRepository.instance = ReviewQueueRepository()
        }
        return ReviewQueueRepository.instance!
    }
    
    private init() {}
    
    
    
    
    func getReviewQueue() -> ReviewQueue? {
        reviewQueue
    }
    
    func saveReviewQueue(_ reviewQueue: ReviewQueue) {
        self.reviewQueue = reviewQueue
    }
    
    func deleteReviewQueue() {
        reviewQueue = nil
    }
}
