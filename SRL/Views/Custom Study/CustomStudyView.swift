//
//  CustomStudyView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct CustomStudyView: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var customStudyViewModel: CustomStudyViewModel
    
    @State private var navLinkDueCards: Bool = false
    @State private var navLinkLearningCards: Bool = false
    @State private var navLinkForgottenCards: Bool = false
    @State private var navLinkAllCards: Bool = false
    
    
    init(deckViewModel: DeckViewModel) {
        self.deckViewModel = deckViewModel
        self.customStudyViewModel = CustomStudyViewModel(deckIds: [deckViewModel.deck.id])
        
    }
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: ReviewView(deckIds: [deckViewModel.deck.id], reviewType: .REGULAR),
                    isActive: $navLinkDueCards,
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"Due Cards"},
                            textRight: {"\(customStudyViewModel.regularReviewQueue.getReviewableCardCount())"})
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        openRegularQueue()
                    })
                    .disabled(checkRegularQueueIsEmpty())
                NavigationLink(
                    destination: ReviewView(deckIds: [deckViewModel.deck.id], reviewType: .LEARNING),
                    isActive: $navLinkLearningCards,
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"Learning Cards"},
                            textRight: {"\(customStudyViewModel.learningReviewQueue.getReviewableCardCount())"})
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        openLearningQueue()
                    })
                    .disabled(checkLearningQueueIsEmpty())
                NavigationLink(
                    destination: ReviewView(deckIds: [deckViewModel.deck.id], reviewType: .LAPSING),
                    isActive: $navLinkForgottenCards,
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"Forgotten Cards"},
                            textRight: {"\(customStudyViewModel.forgottenReviewQueue.getReviewableCardCount())"})
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        openForgottenQueue()
                    })
                    .disabled(checkForgottenQueueIsEmpty())
                NavigationLink(
                    destination: ReviewView(deckIds: [deckViewModel.deck.id], reviewType: .ALLCARDS),
                    isActive: $navLinkAllCards,
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"All Cards"},
                            textRight: {"\(customStudyViewModel.allReviewQueue.getReviewableCardCount())"})
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        openAllQueue()
                    })
                    .disabled(checkAllQueueIsEmpty())
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
    
    private func openRegularQueue() {
        ReviewQueueService().makeReviewQueue(deckIds: [deckViewModel.deck.id], reviewType: .REGULAR)
        navLinkDueCards = true
    }
    
    private func checkRegularQueueIsEmpty() -> Bool {
        customStudyViewModel.regularReviewQueue.getReviewableCardCount() == 0
    }
    
    private func openLearningQueue() {
        ReviewQueueService().makeReviewQueue(deckIds: [deckViewModel.deck.id], reviewType: .LEARNING)
        navLinkLearningCards = true
    }
    
    private func checkLearningQueueIsEmpty() -> Bool {
        customStudyViewModel.learningReviewQueue.getReviewableCardCount() == 0
    }
    
    private func openForgottenQueue() {
        ReviewQueueService().makeReviewQueue(deckIds: [deckViewModel.deck.id], reviewType: .LAPSING)
        navLinkForgottenCards = true
    }
    
    private func checkForgottenQueueIsEmpty() -> Bool {
        customStudyViewModel.forgottenReviewQueue.getReviewableCardCount() == 0
    }
    
    private func openAllQueue() {
        ReviewQueueService().makeReviewQueue(deckIds: [deckViewModel.deck.id], reviewType: .ALLCARDS)
        navLinkAllCards = true
    }
    
    private func checkAllQueueIsEmpty() -> Bool {
        customStudyViewModel.allReviewQueue.getReviewableCardCount() == 0
    }
}
