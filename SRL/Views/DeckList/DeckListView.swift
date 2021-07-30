//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct DeckListView: View {
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var storeViewModel: StoreViewModel
    
    @State private var isShowingNewDeckSheet: Bool = false
    

    var body: some View {
        NavigationView {
            List {
                ForEach(storeViewModel.orderedDecks) { deck in
                    NavigationLink(destination: DeckView(deck: deck, presetViewModel: presetViewModel)) {
//                        ListRowHorizontalSeparatedDirect(textLeft: deck.name, textRight: "\(storeViewModel.reviewQueues[deck.id]!.getReviewableCardCount())")
                        HStack {
                            Text(deck.name)
                            Spacer()
                            Text("\(storeViewModel.reviewQueues[deck.id]!.getReviewableCardCount())")
                                .padding(.horizontal)
                        }
                    }
                }
                .onDelete(perform: storeViewModel.dropDecks)
                ForEach(storeViewModel.reviewQueues.map{ _, queue in queue }) { queue in
                    Text("\(queue.getReviewableCardCount())")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Decks", displayMode: .inline)
            .navigationBarItems(leading: NavButtonAddDeck(isShowingNewDeckSheet: $isShowingNewDeckSheet))
            .sheet(isPresented: $isShowingNewDeckSheet, content: {
                NewDeck(presetViewModel: presetViewModel, storeViewModel: storeViewModel, isShowingBottomSheet: $isShowingNewDeckSheet)
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    struct NavButtonAddDeck: View {
        @Binding var isShowingNewDeckSheet: Bool
        
        var body: some View {
            Button(action: {
                isShowingNewDeckSheet = true
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            })
        }
    }
}
