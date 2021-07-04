//
//  EditDeckSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct EditDeckSheet: ViewModifier {
    var deckViewModel: DeckViewModel
    var presetViewModel: PresetViewModel
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @State private var formDeckName: String = ""
    @State private var formPresetIndex: Int = 0
    
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.allowContentDrag, .swipeToDismiss, .tapToDissmiss],
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
        VStack(spacing: 0) {
            List {
                TextField("Deck Name", text: $formDeckName)
                Picker(selection: $formPresetIndex, label: Text("Preset")) {
                    ForEach(0 ..< presetViewModel.presets.count) {
                        Text(presetViewModel.presets[$0].name)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            Button(action: {
                editDeckAction(deckName: formDeckName, presetIndex: formPresetIndex)
            }, label: {
                Text("Edit Deck")
                    .bold()
            })
            Spacer()
        }
    }
    
    private func editDeckAction(deckName: String, presetIndex: Int) {
        deckViewModel.editDeck(name: deckName, presetIndex: presetIndex)
        isShowingBottomSheet = .hidden
    }
    
    private func refreshEditDeckFormValues() {
        formDeckName = deckViewModel.deck.name
        formPresetIndex = presetViewModel.getPresetIndexOrDefault(forId: deckViewModel.deck.schedulePreset.id)
    }
}
