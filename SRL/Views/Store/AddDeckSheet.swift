//
//  AddDeckSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 05.07.21.
//

import SwiftUI

struct AddDeckSheet: ViewModifier {
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var storeViewModel: StoreViewModel
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var opacityBottomSheet: Double
    @Binding var formDeckName: String
    @Binding var formPresetIndex: Int
    
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.swipeToDismiss, .tapToDissmiss, .noBottomPosition], headerContent: sheetHeader, mainContent: sheetContent, opacity: $opacityBottomSheet)
    }
    
    private func sheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Add Deck")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func sheetContent() -> some View {
        VStack {
            List {
                TextField("Deck Name", text: $formDeckName)
                    .disableAutocorrection(true)
                Picker(selection: $formPresetIndex, label: Text("Preset")) {
                    ForEach(0 ..< presetViewModel.orderedPresets.count) {
                        Text(self.presetViewModel.orderedPresets[$0].name)
                    }
                }
                Section {
                    Button(action: createDeckButtonAction, label: {
                        HStack {
                            Spacer()
                            Text("Create")
                                .bold()
                            Spacer()
                        }
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    private func createDeckButtonAction() {
        createNewDeckInModel(name: formDeckName, presetIndex: formPresetIndex)
        formDeckName = ""
        formPresetIndex = 0
        isShowingBottomSheet = .hidden
    }
    
    private func createNewDeckInModel(name: String, presetIndex: Int) {
        let presetId = presetViewModel.orderedPresets[presetIndex].id
        storeViewModel.makeDeck(name: name, presetId: presetId)
    }
}
