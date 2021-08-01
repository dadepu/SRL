//
//  DeckView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    
    @State private var isShowingBottomSheet: Bool = false
    @State private var bottomSheetRemovePosition: BottomSheetPosition = .hidden
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(deck: Deck, presetViewModel: PresetViewModel) {
        self.deckViewModel = DeckViewModel(deck: deck)
        self.presetViewModel = presetViewModel
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: ReviewView(reviewViewModel: ReviewViewModel(deckId: deckViewModel.deck.id, reviewType: .REGULAR)),
                    label: {
                        ListRowHorizontalSeparated(textLeft: {"Review"}, textRight: {"\(deckViewModel.reviewQueue.getReviewableCardCount())"})
                    }).disabled(!validateDeckHasReviewableCards())
                NavigationLink(
                    destination: CustomStudyView(deckViewModel: deckViewModel),
                    label: {
                        Text("Custom Study")
                    })
            }
            Section(header: Text("Actions")) {
                NavigationLink(
                    destination: NewCard(deckViewModel: deckViewModel, presetViewModel: presetViewModel),
                    label: {
                        Text("Add Cards")
                    })
                NavigationLink(
                    destination: CardBrowseView(deckViewModel: deckViewModel, presetViewModel: presetViewModel),
                    label: {
                        Text("Browse Cards")
                    }).disabled(!validateDeckHasCards())
            }
            Section(header: Text("Deck")) {
                NavigationLink(
                    destination: Presets(deck: deckViewModel.deck),
                    label: {
                        Text("Presets")
                    })
                Button("Edit") {
                    isShowingBottomSheet = true
                }
                Button("Delete") {
                    bottomSheetRemovePosition = .middle
                }.foregroundColor(.red)
            }
        }
        .listStyle(GroupedListStyle())
        .modifier(DeleteDeckBottomSheet(presentationMode: presentationMode, isShowingBottomSheet: $bottomSheetRemovePosition, deckViewModel: deckViewModel))
        .sheet(isPresented: $isShowingBottomSheet, content: {
            EditDeck(deckViewModel: deckViewModel, presetViewModel: presetViewModel, isShowingBottomSheet: $isShowingBottomSheet)
        })
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
    
    
    private func validateDeckHasCards() -> Bool {
        deckViewModel.orderedCards.count > 0
    }
    
    private func validateDeckHasReviewableCards() -> Bool {
        deckViewModel.reviewQueue.getReviewableCardCount() > 0
    }
}
