//
//  DeckView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject var deckViewModel: DeckViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Study")) {
                    
                }
                Section(header: Text("Actions")) {
                    
                }
            }
        }
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
}

//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView()
//    }
//}
