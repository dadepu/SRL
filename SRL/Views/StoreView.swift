//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct StoreView: View {
    @ObservedObject var storeViewModel: StoreViewModel
    
    @State private var isBottomSheetPresent = false
    

    var body: some View {
        NavigationView {
            List {
                ForEach(storeViewModel.decks) { deck in
                    NavigationLink(destination: DeckView(deckViewModel: DeckViewModel(deck: deck))) {
                        DeckRow(deckViewModel: DeckViewModel(deck: deck))
                    }
                }
                .onDelete(perform: { indexSet in
                    delete(at: indexSet)
                })
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Decks", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
//                    try! storeViewModel.makeDeck(name: "TH-Koeln")
                    isBottomSheetPresent = true
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
        }
    }
    
    func delete(at offset: IndexSet) {
        let decks: [Deck] = storeViewModel.decks
        for i in offset {
            storeViewModel.dropDeck(id: decks[i].id)
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

