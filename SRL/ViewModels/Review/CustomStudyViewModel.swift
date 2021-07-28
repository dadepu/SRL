//
//  CustomStudyViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.07.21.
//

import Foundation
import Combine

class CustomStudyViewModel: ObservableObject {
    @Published private (set) var currentReviewQueue: ReviewQueue?
    
    @Published private (set) var regularReviewQueue: ReviewQueue
    @Published private (set) var learningReviewQueue: ReviewQueue
    @Published private (set) var forgottenReviewQueue: ReviewQueue
    @Published private (set) var allReviewQueue: ReviewQueue
    
    private var deckObserver: AnyCancellable?
    private var reviewQueueObserver: AnyCancellable?
    
    
    init(deckIds: [UUID]) {
        self.currentReviewQueue = try? ReviewQueueService().getReviewQueue()
        self.regularReviewQueue = ReviewQueueService().makeTransientQueue(deckIds: deckIds, reviewType: .REGULAR)
        self.learningReviewQueue = ReviewQueueService().makeTransientQueue(deckIds: deckIds, reviewType: .LEARNING)
        self.forgottenReviewQueue = ReviewQueueService().makeTransientQueue(deckIds: deckIds, reviewType: .LAPSING)
        self.allReviewQueue = ReviewQueueService().makeTransientQueue(deckIds: deckIds, reviewType: .ALLCARDS)
        
        self.reviewQueueObserver = ReviewQueueService().getModelPublisher().sink { (reviewQueue: ReviewQueue?) in
            self.currentReviewQueue = reviewQueue
        }
    }
}
