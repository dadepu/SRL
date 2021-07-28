//
//  CardBrowser.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardBrowser: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    
    
    init(deckViewModel: DeckViewModel, presetViewModel: PresetViewModel) {
        self.deckViewModel = deckViewModel
        self.presetViewModel = presetViewModel
    }
    
    
    var body: some View {
        if deckViewModel.orderedCards.count > 0 {
            List {
                Section(header: Text("Sort by date created")) {
                    ForEach(deckViewModel.orderedCards) { card in
                        NavigationLink(
                            destination: EditCardView(deckViewModel: deckViewModel, presetViewModel: presetViewModel, deck: deckViewModel.deck, card: card),
                            label: {
                                CardBrowserCard(card: card)
                                    .padding(.trailing, 10)
                            })
                    }.onDelete(perform: { indexSet in
                        deckViewModel.deleteCards(indexSet: indexSet)
                    })
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
        } else {
            Text("Deck is empty")
        }
    }
    
    
}
