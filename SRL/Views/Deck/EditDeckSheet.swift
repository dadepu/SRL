//
//  EditDeckSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct EditDeckSheet: ViewModifier {
    @ObservedObject var deckViewModel: DeckViewModel
    @ObservedObject var presetViewModel: PresetViewModel
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var formDeckName: String
    @Binding var formPresetIndex: Int
    
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.allowContentDrag, .swipeToDismiss, .tapToDissmiss, .noBottomPosition],
                      headerContent: sheetHeader, mainContent: sheetContent)
    }
    
    private func sheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Edit Deck")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func sheetContent() -> some View {
        VStack() {
            List {
                TextField("Deck Name", text: $formDeckName)
                Picker(selection: $formPresetIndex, label: Text("Preset")) {
                    ForEach(0 ..< presetViewModel.presets.count) {
                        Text(presetViewModel.presets[$0].name)
                    }
                }
                Button(action: {
                    editDeckAction(deckName: formDeckName, presetIndex: formPresetIndex)
                }, label: {
                    Text("Edit Deck")
                        .bold()
                })
            }
            .listStyle(GroupedListStyle())
        }
    }
    
    private func editDeckAction(deckName: String, presetIndex: Int) {
        deckViewModel.editDeck(name: deckName, presetIndex: presetIndex)
        refreshEditDeckFormValues()
        isShowingBottomSheet = .hidden
    }
    
    private func refreshEditDeckFormValues() {
        formDeckName = deckViewModel.deck.name
        formPresetIndex = presetViewModel.getPresetIndexOrDefault(forId: deckViewModel.deck.schedulePreset.id)
    }
}
