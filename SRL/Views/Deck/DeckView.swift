//
//  DeckView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel = PresetViewModel()
    
    @State private var bottomSheetEditPosition: BottomSheetPosition = .hidden
    @State private var bottomSheetRemovePosition: BottomSheetPosition = .hidden
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(deck: Deck) {
        self.deckViewModel = DeckViewModel(deck: deck)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        ListRowHorizontalSeparated(textLeft: {"Review"}, textRight: {"\(deckViewModel.deck.reviewQueue.reviewableCardCount)"})
                    })
                NavigationLink(
                    destination: CustomStudyView(deckViewModel: deckViewModel),
                    label: {
                        Text("Custom Study")
                    })
            }
            Section(header: Text("Actions")) {
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Add Cards")
                    })
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Browse Cards")
                    })
            }
            Section(header: Text("Deck")) {
                Button("Presets") {
                    
                }
                Button("Edit") {
                    bottomSheetEditPosition = .middle
                }
                Button("Delete") {
                    bottomSheetRemovePosition = .middle
                }.foregroundColor(.red)
                
            }
        }
        .listStyle(GroupedListStyle())
        .modifier(EditDeckSheet(deckViewModel: deckViewModel, presetViewModel: presetViewModel, isShowingBottomSheet: $bottomSheetEditPosition))
        .modifier(DeleteDeckSheet(presentationMode: presentationMode, isShowingBottomSheet: $bottomSheetRemovePosition, deckViewModel: deckViewModel))
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
}
