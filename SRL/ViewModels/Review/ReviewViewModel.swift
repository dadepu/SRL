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
    private (set) var deckIds: [UUID]
    private (set) var reviewType: ReviewType
    
    private var reviewQueueObserver: AnyCancellable?
    
    
    init(deckIds: [UUID], reviewType: ReviewType) {
        do {
            self.reviewQueue = try ReviewQueueService().getReviewQueue()
        } catch {
            self.reviewQueue = ReviewQueueService().makeReviewQueue(deckIds: deckIds, reviewType: reviewType)
        }
        self.deckIds = deckIds
        self.reviewType = reviewType
        
        self.reviewQueueObserver = ReviewQueueService().getModelPublisher().sink { (updatedReviewQueue: ReviewQueue?) in
            if updatedReviewQueue != nil {
                self.reviewQueue = updatedReviewQueue!
            } else {
                self.reviewQueue = ReviewQueueService().makeReviewQueue(deckIds: deckIds, reviewType: reviewType)
            }
        }
    }

    
    func reviewCard(reviewAction: ReviewAction) {
        do {
            self.reviewQueue = try ReviewQueueService().reviewCard(cardId: reviewQueue.currentCard!.id, reviewAction: reviewAction)
        } catch {
            self.reviewQueue = ReviewQueueService().makeReviewQueue(deckIds: reviewQueue.decks.map {deck in deck.id}, reviewType: reviewType)
        }
    }
}
