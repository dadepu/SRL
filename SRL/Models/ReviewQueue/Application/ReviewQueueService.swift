//
//  ReviewQueueService.swift
//  SRL
//
//  Created by Daniel Koellgen on 13.07.21.
//

import Foundation

struct ReviewQueueService {
    private let reviewQueueRepository = ReviewQueueRepository.getInstance()
    
    
    func getModelPublisher() -> Published<[UUID : ReviewQueue]>.Publisher {
        reviewQueueRepository.$reviewQueues
    }
    
    
    func getReviewQueue(forId id: UUID) -> ReviewQueue? {
        reviewQueueRepository.getReviewQueue(forId: id)
    }
    
    func makeReviewQueue(decks: [Deck], reviewType: ReviewType) -> ReviewQueue {
        let reviewQueue = ReviewQueue(decks: decks, reviewType: reviewType)
        reviewQueueRepository.saveReviewQueues(reviewQueue)
        return reviewQueue
    }
    
    func makeTransientQueue(decks: [Deck], reviewType: ReviewType) -> ReviewQueue {
        ReviewQueue(decks: decks, reviewType: reviewType)
    }
    
    func deleteAllReviewQueues() {
        reviewQueueRepository.deleteAllReviewQueues()
    }
}
