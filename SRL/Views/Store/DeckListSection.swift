//
//  DeckListSection.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct DeckListSection: View {
    private var presetViewModel: PresetViewModel
    private var storeViewModel: StoreViewModel
    private var decks: [Deck]
    
    
    init(storeViewModel: StoreViewModel, presetViewModel: PresetViewModel) {
        self.presetViewModel = presetViewModel
        self.storeViewModel = storeViewModel
        self.decks = storeViewModel.decks
    }
    
    
    var body: some View {
        List {
            ForEach(decks) { deck in
                NavigationLink(destination: DeckView(deck: deck, presetViewModel: presetViewModel)) {
                    ListRowHorizontalSeparated(textLeft: {deck.name}, textRight: {"\(deck.reviewQueue.reviewableCardCount)"})
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
