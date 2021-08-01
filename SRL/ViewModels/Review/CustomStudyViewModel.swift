//
//  CustomStudyViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.07.21.
//

import Foundation
import Combine

class CustomStudyViewModel: ObservableObject {
    @Published private (set) var regularReviewQueue: ReviewQueue
    @Published private (set) var learningReviewQueue: ReviewQueue
    @Published private (set) var forgottenReviewQueue: ReviewQueue
    @Published private (set) var allReviewQueue: ReviewQueue
    
    private var deckId: UUID
    
    private var deckObserver: AnyCancellable?
    
    
    init(deckId: UUID) {
        self.deckId = deckId
        self.regularReviewQueue = ReviewQueueService().makeTransientQueue(deckId: deckId, reviewType: .REGULAR)
        self.learningReviewQueue = ReviewQueueService().makeTransientQueue(deckId: deckId, reviewType: .LEARNING)
        self.forgottenReviewQueue = ReviewQueueService().makeTransientQueue(deckId: deckId, reviewType: .LAPSING)
        self.allReviewQueue = ReviewQueueService().makeTransientQueue(deckId: deckId, reviewType: .ALLCARDS)
        
        deckObserver = DeckService().getModelPublisher().sink { (decks: [UUID:Deck]) in
            // rebuild queues
        }
    }
}
