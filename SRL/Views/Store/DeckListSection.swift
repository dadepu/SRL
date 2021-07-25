//
//  DeckListSection.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct DeckListSection: View {
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var storeViewModel: StoreViewModel
    
    
    init(storeViewModel: StoreViewModel, presetViewModel: PresetViewModel) {
        self.presetViewModel = presetViewModel
        self.storeViewModel = storeViewModel
    }
    
    
    var body: some View {
        List {
            ForEach(storeViewModel.decks) { deck in
                NavigationLink(destination: DeckView(deck: deck, presetViewModel: presetViewModel)) {
                    ListRowHorizontalSeparated(textLeft: {deck.name}, textRight: {"\(storeViewModel.reviewQueues[deck.id]!.getReviewableCardCount())"})
                }
            }
            .onDelete(perform: deleteDeck)
            .onMove(perform: { indices, newOffset in
                print(indices, newOffset)
            })
        }
        .listStyle(GroupedListStyle())
    }
    
    
    func deleteDeck(at offset: IndexSet) {
        let decks: [Deck] = storeViewModel.decks
        for i in offset {
            storeViewModel.dropDeck(id: decks[i].id)
        }
    }
}
