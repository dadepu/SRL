//
//  DeckListSection.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct DeckListSection: View {
    @ObservedObject var storeViewModel: StoreViewModel
    var decks: [Deck]
    
    
    var body: some View {
        List {
            ForEach(decks) { deck in
                NavigationLink(destination: DeckView(deckViewModel: DeckViewModel(deck: deck))) {
                    DeckRow(deckViewModel: DeckViewModel(deck: deck))
                }
            }
            .onDelete(perform: deleteDeck)
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
