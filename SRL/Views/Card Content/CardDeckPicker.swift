//
//  CardDeckPicker.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct CardDeckPicker: View {
    @ObservedObject var storeViewModel: StoreViewModel
    @ObservedObject var editCardViewModel: EditCardViewModel
    @State var deckIndex: UUID
    
    var body: some View {
        Picker(selection: $deckIndex, label: Text("Deck")) {
            ForEach(storeViewModel.orderedDecks) { deck in
                Text(deck.name)
            }
        }.onChange(of: deckIndex, perform: { deckId in
            editCardViewModel.setTransferDeckId(destinationId: deckId)
        })
    }
}
