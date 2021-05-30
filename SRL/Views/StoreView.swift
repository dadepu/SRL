//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct StoreView: View {
    @ObservedObject var storeViewModel: StoreViewModel
    
    var body: some View {
        NavigationView {
                Text("")
                .navigationBarTitle("Decks", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        //TODO
                        storeViewModel.createNewDeck(name: "Test")
                    }, label: {
                        Image(systemName: "plus").imageScale(.large)
                    }),
                    trailing: EditButton()
                )
        }
    }
}



struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StoreView(storeViewModel: StoreViewModel(deckService: DeckApiService()))
        }
    }
}
