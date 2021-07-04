//
//  CustomStudyView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct CustomStudyView: View {
    @ObservedObject var deckViewModel: DeckViewModel
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Due Cards")
                    })
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("New Cards")
                    })
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Forgotten Cards")
                    })
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("All Cards")
                    })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
}
