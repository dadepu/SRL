//
//  EditDeck.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct EditDeck: View {
    @ObservedObject var deckViewModel: DeckViewModel
    @ObservedObject var presetViewModel: PresetViewModel
    
    @Binding var isShowingBottomSheet: Bool
    
    var body: some View {
        NavigationView {
            DeckForm<EditDeckButton>(presetViewModel: presetViewModel, formDeckName: deckViewModel.deck.name, formPresetId: deckViewModel.deck.schedulePreset.id,
                FormButton: { deckForm in
                    EditDeckButton(deckViewModel: deckViewModel, formDeckName: deckForm.$formDeckName, formPresetId: deckForm.$formPresetId, isShowingBottomSheet: $isShowingBottomSheet)
                })
            .navigationBarTitle(Text("Edit Deck"))
        }
    }
    
    struct EditDeckButton: View {
        var deckViewModel: DeckViewModel
        
        @Binding var formDeckName: String
        @Binding var formPresetId: UUID
    
        @Binding var isShowingBottomSheet: Bool
        
        var body: some View {
            Button(action: {
                if validInput() {
                    deckViewModel.editDeck(name: formDeckName, presetId: formPresetId)
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
