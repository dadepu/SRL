//
//  NewDeck.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct NewDeck: View {
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var storeViewModel: StoreViewModel
    
    @Binding var isShowingBottomSheet: Bool
    
    var body: some View {
        NavigationView {
            DeckForm<NewDeckButton>(presetViewModel: presetViewModel, formDeckName: "", formPresetId: PresetViewModel.getDefaultPreset().id,
                FormButton: { deckForm in
                    NewDeckButton(storeViewModel: storeViewModel, formDeckName: deckForm.$formDeckName, formPresetId: deckForm.$formPresetId, isShowingBottomSheet: $isShowingBottomSheet)
                })
            .navigationBarTitle(Text("New Deck"))
        }
    }
    
    struct NewDeckButton: View {
        var storeViewModel: StoreViewModel
        
        @Binding var formDeckName: String
        @Binding var formPresetId: UUID
        
        @Binding var isShowingBottomSheet: Bool
        
        var body: some View {
            Button(action: {
                if validInput() {
                    storeViewModel.makeDeck(name: formDeckName, presetId: formPresetId)
                    isShowingBottomSheet = false
                }
            }, label: {
                HStack {
                    Spacer()
                    Text("Save Deck")
                        .bold()
                    Spacer()
                }
            }).disabled(!validInput())
        }
        
        func validInput() -> Bool {
            !formDeckName.isEmpty
        }
    }
}
