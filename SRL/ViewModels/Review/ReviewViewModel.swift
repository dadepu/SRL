//
//  ReviewViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import Foundation
import Combine

class ReviewViewModel: ObservableObject {
    @Published private (set) var reviewQueue: ReviewQueue
    private (set) var deckId: UUID
    private (set) var reviewType: ReviewType
    
    private var reviewQueueObserver: AnyCancellable?
    
    
    init(deckId: UUID, reviewType: ReviewType) {
        self.reviewQueue = ReviewQueueService().makeReviewQueue(deckId: deckId, reviewType: reviewType)
        self.deckId = deckId
        self.reviewType = reviewType
        
        self.reviewQueueObserver = ReviewQueueService().getModelPublisher().sink { (reviewQueues: [UUID:ReviewTypes]) in
            // neue laden oder neue machen wenn gelöscht
            guard let reviewQueue = reviewQueues[self.deckId]?.getQueue(type: reviewType) else {
                self.reviewQueue = ReviewQueueService().makeReviewQueue(deckId: deckId, reviewType: reviewType)
                return
            }
            self.reviewQueue = reviewQueue
        }
    }
    
    func reviewCard(reviewAction: ReviewAction) {
        do {
            self.reviewQueue = try ReviewQueueService().reviewCard(deckId: deckId, cardId: reviewQueue.currentCard!.id, reviewType: reviewType, reviewAction: reviewAction)
        } catch {
            self.reviewQueue = ReviewQueueService().makeReviewQueue(deckId: deckId, reviewType: reviewType)
        }
    }
}
