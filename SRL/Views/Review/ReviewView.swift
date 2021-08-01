//
//  ReviewView.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    
    @State private var displayMode: DisplayMode = .question
    
    

    var body: some View {
        Group {
            if hasCardToDisplay() {
                switch (reviewViewModel.reviewQueue.currentCard!.content){
                    case .DEFAULT(let defaultCard):
                        ReviewDefaultCard(reviewViewModel: reviewViewModel, displayMode: $displayMode, card: reviewViewModel.reviewQueue.currentCard!, content: defaultCard)
                    case .TYPING(let typingCard):
                            ReviewTypingCard(reviewViewModel: reviewViewModel, displayMode: $displayMode, card: reviewViewModel.reviewQueue.currentCard!, content: typingCard)
                }
            } else {
                Text("No Cards remaining")
            }
        }
        .navigationBarTitle("Review (\(reviewViewModel.reviewQueue.getReviewableCardCount()) Cards)", displayMode: .inline)
    }
    
    
    private func hasCardToDisplay() -> Bool {
        reviewViewModel.reviewQueue.currentCard != nil
    }
    
    enum DisplayMode {
        case question
        case revealed
    }
}
