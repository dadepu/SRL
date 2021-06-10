//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI
import UIKit

struct StoreView: View {
    @EnvironmentObject var deckApiService: DeckApiService
    @ObservedObject var storeViewModel: StoreViewModel
    
    @State var alertNewDeck = false

    var body: some View {
        NavigationView {
            List(storeViewModel.decks) { (deck: Deck) in
                NavigationLink(destination: DeckView(deckViewModel: DeckViewModel(deckApiService, deck: deck))) {
                    DeckRow(deckViewModel: DeckViewModel(deckApiService, deck: deck))
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Decks", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    storeViewModel.makeNewDeck(name: "TH-Koeln")
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
        }
    }
}



//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StoreView(storeViewModel: StoreViewModel(DeckApiService()))
//        }
//    }
//}

