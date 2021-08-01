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
        self.customStudyViewModel = CustomStudyViewModel(deckId: deckViewModel.deck.id)
    }
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: ReviewView(reviewViewModel: ReviewViewModel(deckId: deckViewModel.deck.id, reviewType: .REGULAR)),
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"Due Cards"},
                            textRight: {"\(customStudyViewModel.regularReviewQueue.getReviewableCardCount())"})
                    })
                    .disabled(checkRegularQueueIsEmpty())
                NavigationLink(
                    destination: ReviewView(reviewViewModel: ReviewViewModel(deckId: deckViewModel.deck.id, reviewType: .LEARNING)),
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"Learning Cards"},
                            textRight: {"\(customStudyViewModel.learningReviewQueue.getReviewableCardCount())"})
                    })
                    .disabled(checkLearningQueueIsEmpty())
                NavigationLink(
                    destination: ReviewView(reviewViewModel: ReviewViewModel(deckId: deckViewModel.deck.id, reviewType: .LAPSING)),
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"Forgotten Cards"},
                            textRight: {"\(customStudyViewModel.forgottenReviewQueue.getReviewableCardCount())"})
                    })
                    .disabled(checkForgottenQueueIsEmpty())
                NavigationLink(
                    destination: ReviewView(reviewViewModel: ReviewViewModel(deckId: deckViewModel.deck.id, reviewType: .ALLCARDS)),
                    label: {
                        ListRowHorizontalSeparated(
                            textLeft: {"All Cards"},
                            textRight: {"\(customStudyViewModel.allReviewQueue.getReviewableCardCount())"})
                    })
                    .disabled(checkAllQueueIsEmpty())
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }

    private func checkRegularQueueIsEmpty() -> Bool {
        customStudyViewModel.regularReviewQueue.getReviewableCardCount() == 0
    }

    private func checkLearningQueueIsEmpty() -> Bool {
        customStudyViewModel.learningReviewQueue.getReviewableCardCount() == 0
    }

    private func checkForgottenQueueIsEmpty() -> Bool {
        customStudyViewModel.forgottenReviewQueue.getReviewableCardCount() == 0
    }

    private func checkAllQueueIsEmpty() -> Bool {
        customStudyViewModel.allReviewQueue.getReviewableCardCount() == 0
    }
}
