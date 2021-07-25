//
//  ReviewViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import Foundation
import Combine

class ReviewViewModel: ObservableObject {
    private (set) var id = UUID()
    @Published private (set) var reviewQueue: ReviewQueue
    
    private var reviewService = ReviewQueueService()
    private (set) var reviewType: ReviewType
    
    private var deckObserver: AnyCancellable?
    private var cardObserver: AnyCancellable?
    
    
    init(deckIds: [UUID], reviewType: ReviewType) {
        self.reviewQueue = reviewService.makeReviewQueue(deckIds: deckIds, reviewType: reviewType)
        self.reviewType = reviewType
//        deckObserver = DeckService().getModelPublisher().sink(receiveValue: refreshReviewQueue(withDecks:))
//        cardObserver = CardService().getModelPublisher().sink(receiveValue: refreshReviewQueue(withCards:))
    }
    
    func getReviewCardCount() -> Int {
        reviewQueue.getReviewableCardCount()
    }
    
//    private func refreshReviewQueue(withDecks decks: [UUID:Deck]) {
//        let refreshedQueue = reviewService.refreshReviewQueue(reviewQueue, withDecks: decks.map { key, value in value })
//        self.reviewQueue = refreshedQueue
//    }
    
//    private func refreshReviewQueue(withCards cards: [UUID:Card]) {
//        let refreshedQueue = reviewService.refreshReviewQueue(reviewQueue, withCards: cards.map { key, value in value })
//        self.reviewQueue = refreshedQueue
//    }
    
    func reviewCard(reviewAction: ReviewAction) {
        let refreshedQueue = try! reviewService.reviewCard(reviewQueueId: reviewQueue.id, cardId: reviewQueue.currentCard!.id, reviewAction: reviewAction)
        self.reviewQueue = refreshedQueue
        
//        do {
//            print("review queue id: \(reviewQueue.id)")
//            print("before review current card: \(reviewQueue.currentCard?.id)")
//            let refreshedQueue = try reviewService.reviewCard(reviewQueueId: reviewQueue.id, cardId: reviewQueue.currentCard!.id, reviewAction: reviewAction)
//            self.reviewQueue = refreshedQueue
//            print("after review current card: \(reviewQueue.currentCard?.id)")
//            print("refreshedQueue.cardCount = \(refreshedQueue.getReviewableCardCount())")
//            print("----")
//        } catch {
//            print("Caught error")
////            self.reviewQueue = reviewService.makeReviewQueue(decks: reviewQueue.decks, reviewType: reviewQueue.reviewType)
////            self.currentCard = reviewQueue.currentCard
//        }
    }
}
