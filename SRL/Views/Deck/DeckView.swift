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
    
    @State private var bottomSheetEditPosition: BottomSheetPosition = .hidden
    @State private var bottomSheetRemovePosition: BottomSheetPosition = .hidden
    @State private var navLinkDueCards: Bool = false
    
    @State private var formDeckName: String = ""
    @State private var formPresetIndex: Int = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(deck: Deck, presetViewModel: PresetViewModel) {
        self.deckViewModel = DeckViewModel(deck: deck)
        self.presetViewModel = presetViewModel
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: ReviewView(deckIds: [deckViewModel.deck.id], reviewType: .REGULAR),
                    isActive: $navLinkDueCards,
                    label: {
                        ListRowHorizontalSeparated(textLeft: {"Review"}, textRight: {"\(deckViewModel.reviewQueue.getReviewableCardCount())"})
                    }).simultaneousGesture(TapGesture().onEnded {
                        ReviewQueueService().makeReviewQueue(deckIds: [deckViewModel.deck.id], reviewType: .REGULAR)
                        navLinkDueCards = true
                    }).disabled(deckViewModel.reviewQueue.getReviewableCardCount() == 0)
                NavigationLink(
                    destination: CustomStudyView(deckViewModel: deckViewModel),
                    label: {
                        Text("Custom Study")
                    })
            }
            Section(header: Text("Actions")) {
                NavigationLink(
                    destination: CreateCardView(deckViewModel: deckViewModel, presetViewModel: presetViewModel),
                    label: {
                        Text("Add Cards")
                    })
                NavigationLink(
                    destination: CardBrowser(deckViewModel: deckViewModel, presetViewModel: presetViewModel),
                    label: {
                        Text("Browse Cards")
                    }).disabled(deckViewModel.orderedCards.count == 0)
            }
            Section(header: Text("Deck")) {
                NavigationLink(
                    destination: Presets(deck: deckViewModel.deck),
                    label: {
                        Text("Presets")
                    })
                Button("Edit") {
                    refreshEditDeckFormValues()
                    bottomSheetEditPosition = .middle
                }
                Button("Delete") {
                    bottomSheetRemovePosition = .middle
                }.foregroundColor(.red)
            }
        }
        .listStyle(GroupedListStyle())
        .modifier(EditDeckSheet(deckViewModel: deckViewModel, presetViewModel: presetViewModel, isShowingBottomSheet: $bottomSheetEditPosition, formDeckName: $formDeckName, formPresetIndex: $formPresetIndex))
        .modifier(DeleteDeckSheet(presentationMode: presentationMode, isShowingBottomSheet: $bottomSheetRemovePosition, deckViewModel: deckViewModel))
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
    
    
    
    private func refreshEditDeckFormValues() {
        formDeckName = deckViewModel.deck.name
        formPresetIndex = presetViewModel.getPresetOrDefaultIndex(forId: deckViewModel.deck.schedulePreset.id)
    }
}
