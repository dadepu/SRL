//
//  ReviewView.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject private var reviewViewModel: ReviewViewModel
    
    @State private var displayMode: DisplayMode = .question
    @State private var isShowingBottomSheetCustomInterval: BottomSheetPosition = .hidden
    @State private var opacityBottomUpSheets: Double = 0
    
    
    init(deckIds: [UUID], reviewType: ReviewType) {
        self.reviewViewModel = ReviewViewModel(deckIds: deckIds, reviewType: reviewType)
    }
    
    
    var body: some View {
        Group {
            if hasCardToDisplay() {
                DisplayCard(reviewViewModel: reviewViewModel, displayMode: $displayMode, isShowingBottomSheetCustomInterval: $isShowingBottomSheetCustomInterval, opacityBottomUpSheets: $opacityBottomUpSheets)
            } else {
                NoCardsToDisplay()
            }
        }
        .navigationBarTitle("Review (\(reviewViewModel.reviewQueue.getReviewableCardCount()) Cards)", displayMode: .inline)
    }
    
    
    private func hasCardToDisplay() -> Bool {
        reviewViewModel.reviewQueue.currentCard != nil
    }
    
    private struct DisplayCard: View {
        @ObservedObject var reviewViewModel: ReviewViewModel
        @Binding var displayMode: DisplayMode
        @Binding var isShowingBottomSheetCustomInterval: BottomSheetPosition
        @Binding var opacityBottomUpSheets: Double
        
        var body: some View {
            List {
                if let currentCard = reviewViewModel.reviewQueue.currentCard {
                    DisplayCardContent(displayMode: $displayMode, card: currentCard)
                } else {
                    EmptyView()
                }
            }
            .listStyle(GroupedListStyle())
            .onTapGesture(perform: {displayMode = .revealed})
//            .modifier(ReviewCustomIntervalSheet(reviewViewModel: reviewViewModel, isShowingBottomSheet: $isShowingBottomSheetCustomInterval, opacityBottomSheet: $opacityBottomUpSheets))
            DisplayButtonFooter(reviewViewModel: reviewViewModel, displayMode: $displayMode, isShowingBottomSheetCustomInterval: $isShowingBottomSheetCustomInterval, opacityBottomUpSheets: $opacityBottomUpSheets)
                
        }
    }
    
    private struct NoCardsToDisplay: View {
        var body: some View {
            Text("No Cards remaining")
        }
    }
    
    private struct DisplayCardContent: View {
        @Binding var displayMode: DisplayMode
        var card: Card

        var body: some View {
            Section(header: Text("Question")) {
                Group {
                    switch (card.content) {
                    case .DEFAULT(let defaultCard):
                        ForEach(defaultCard.questionContent) { cardContentContainer in
                            CardContent(cardContent: cardContentContainer)
                        }
                    case .TYPING(_): EmptyView()
                    }
                }
            }
            if (displayMode == .revealed) {
                Section(header: Text("Answer")) {
                    Group {
                        switch (card.content) {
                        case .DEFAULT(let defaultCard):
                            ForEach(defaultCard.answerContent) { cardContentContainer in
                                CardContent(cardContent: cardContentContainer)
                            }
                        case .TYPING(_): EmptyView()
                        }
                    }
                }
            }
        }
    }
    
    private struct DisplayButtonFooter: View {
        @ObservedObject var reviewViewModel: ReviewViewModel
        @Binding var displayMode: DisplayMode
        @Binding var isShowingBottomSheetCustomInterval: BottomSheetPosition
        @Binding var opacityBottomUpSheets: Double
        
        var body: some View {
            if displayMode == .revealed, isShowingBottomSheetCustomInterval == .hidden {
                LazyVStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            reviewViewModel.reviewCard(reviewAction: .REPEAT)
                            displayMode = .question
                        }) {
                            Text("Bad")
                        }.padding()
                        Spacer()
                        Button(action: {
                            reviewViewModel.reviewCard(reviewAction: .HARD)
                            displayMode = .question
                        }) {
                            Text("Hard")
                        }.padding()
                        Spacer()
                        Button(action: {
                            reviewViewModel.reviewCard(reviewAction: .GOOD)
                            displayMode = .question
                        }) {
                            Text("Good")
                        }.padding()
                        Spacer()
                        Button(action: {
                            reviewViewModel.reviewCard(reviewAction: .EASY)
                            displayMode = .question
                        }) {
                            Text("Easy")
                        }.padding()
                        Spacer()
                    }
                }
            } else {
                EmptyView()
            }
        }
    }

    
    private enum DisplayMode {
        case question
        case revealed
    }
}
