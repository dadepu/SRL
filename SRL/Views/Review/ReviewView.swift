//
//  ReviewView.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var reviewViewModel: ReviewViewModel
    
    @State private var displayMode: DisplayMode = .question
    @State private var isShowingBottomSheetCustomInterval: BottomSheetPosition = .hidden
    @State private var opacityBottomUpSheets: Double = 0
    
    
    init(presetViewModel: PresetViewModel, deckIds: [UUID], reviewType: ReviewType) {
        self.presetViewModel = presetViewModel
        self.reviewViewModel = ReviewViewModel(deckIds: deckIds, reviewType: reviewType)
    }
    
    
    var body: some View {
        List {
            Text("ReviewQueue ID: \(reviewViewModel.reviewQueue.id)")
            ForEach(reviewViewModel.reviewQueue.decks) { deck in
                Text("\(deck.name)")
            }
        }
        .listStyle(GroupedListStyle())
        LazyVStack {
            HStack {
                Spacer()
                Button(action: {reviewViewModel.reviewCard(reviewAction: .REPEAT)}) {
                    Text("Bad")
                }
                .padding()
                Spacer()
                Button(action: {reviewViewModel.reviewCard(reviewAction: .GOOD)}) {
                    Text("Good")
                }.padding()
                Spacer()
                Button(action: {reviewViewModel.reviewCard(reviewAction: .EASY)}) {
                    Text("Easy")
                }.padding()
                Spacer()
                Button(action: {}) {
                    Text("Custom")
                }.padding()
                Spacer()
            }
        }.navigationBarTitle("Review (\(reviewViewModel.reviewQueue.getReviewableCardCount()) Cards)", displayMode: .inline)
    }
    
//    private struct DisplayCardContent: View {
//        var card: Card
//
//        var body: some View {
//            Section(header: Text("Question")) {
//                Group {
//                    switch (card.content) {
//                    case .DEFAULT(let defaultCard):
//                        ForEach(defaultCard.questionContent) { cardContentContainer in
//                            CardContent(cardContent: cardContentContainer)
//                        }
//                    case .TYPING(_): Text("")
//                    }
//                }
//            }
//            Section(header: Text("Answer")) {
//                Group {
//                    switch (card.content) {
//                    case .DEFAULT(let defaultCard):
//                        ForEach(defaultCard.answerContent) { cardContentContainer in
//                            CardContent(cardContent: cardContentContainer)
//                        }
//                    case .TYPING(_): Text("")
//                    }
//                }
//            }
//        }
//    }
//
//    private struct ReviewQueueEmpty: View {
//        var body: some View {
//            Text("No Cards left to review")
//        }
//    }
    
    private enum DisplayMode {
        case question
        case revealed
    }
}
