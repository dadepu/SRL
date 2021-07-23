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
                    destination: EmptyView(),
                    label: {
                        Text("Due Cards")
                    })
                NavigationLink(
                    destination: EmptyView(),
                    label: {
                        Text("New Cards")
                    })
                NavigationLink(
                    destination: EmptyView(),
                    label: {
                        Text("Forgotten Cards")
                    })
                NavigationLink(
                    destination: EmptyView(),
                    label: {
                        Text("All Cards")
                    })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
}
