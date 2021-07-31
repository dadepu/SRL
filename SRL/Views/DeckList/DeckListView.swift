//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct DeckListView: View {
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var storeViewModel: StoreViewModel
    
    @State private var isShowingNewDeckSheet: Bool = false
    @State private var isShowingNotificationSheet: Bool = false
    

    var body: some View {
        NavigationView {
            List {
                ForEach(storeViewModel.orderedDecks) { deck in
                    NavigationLink(destination: DeckView(deck: deck, presetViewModel: presetViewModel)) {
                        ListRowHorizontalSeparated(textLeft: {"\(deck.name)"}, textRight: {""})
                    }
                }
                .onDelete(perform: storeViewModel.dropDecks)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Decks", displayMode: .inline)
            .navigationBarItems(leading: NavButtonAddDeck(isShowingNewDeckSheet: $isShowingNewDeckSheet), trailing: NotificationButton(isShowingNotificationSheet: $isShowingNotificationSheet))
        
            .sheet(isPresented: $isShowingNewDeckSheet, content: {
                NewDeck(presetViewModel: presetViewModel, storeViewModel: storeViewModel, isShowingBottomSheet: $isShowingNewDeckSheet)
            })
            .sheet(isPresented: $isShowingNotificationSheet, content: {
                ManageNotifications(notificationViewModel: notificationViewModel, isShowingBottomSheet: $isShowingNotificationSheet)
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
    
    struct NotificationButton: View {
        @Binding var isShowingNotificationSheet: Bool
        
        var body: some View {
            Button(action: {
                isShowingNotificationSheet = true
            }, label: {
                Image(systemName: "bell").imageScale(.large)
            })
        }
    }
}
