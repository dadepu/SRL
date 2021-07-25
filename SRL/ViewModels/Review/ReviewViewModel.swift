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
    private (set) var reviewType: ReviewType
    
    private var deckObserver: AnyCancellable?
    
    
    init(deckIds: [UUID], reviewType: ReviewType) {
        self.reviewQueue = ReviewQueueService().makeTransientQueue(deckIds: deckIds, reviewType: reviewType)
        self.reviewType = reviewType
    }

    
    func reviewCard(reviewAction: ReviewAction) {
        do {
            self.reviewQueue = try ReviewQueueService().reviewCard(reviewQueue: reviewQueue, cardId: reviewQueue.currentCard!.id, reviewAction: reviewAction)
        } catch {
            self.reviewQueue = ReviewQueueService().makeTransientQueue(deckIds: reviewQueue.decks.map {deck in deck.id}, reviewType: reviewType)
        }
    }
}
