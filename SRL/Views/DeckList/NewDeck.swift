//
//  AddDeckSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 05.07.21.
//

import SwiftUI

struct NewDeck: View {
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var storeViewModel: StoreViewModel
    
    @Binding var isShowingBottomSheet: Bool
    @State var formDeckName: String = ""
    @State var formPresetId: UUID = PresetViewModel.getDefaultPreset().id
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Deck")) {
                    TextField("Deck Name", text: $formDeckName)
                        .disableAutocorrection(true)
                    Picker(selection: $formPresetId, label: Text("Preset")) {
                        ForEach(presetViewModel.orderedPresets) { preset in
                            Text(preset.name)
                                .tag(preset.id)
                        }
                    }
                }
                Section {
                    SaveButton(storeViewModel: storeViewModel, isShowingBottomSheet: $isShowingBottomSheet, formDeckName: $formDeckName, formPresetId: $formPresetId)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("New Deck"))
        }
    }
    
    private struct SaveButton: View {
        var storeViewModel: StoreViewModel
        
        @Binding var isShowingBottomSheet: Bool
        @Binding var formDeckName: String
        @Binding var formPresetId: UUID
        
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
