//
//  AddDeckSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 05.07.21.
//

import SwiftUI

struct DeckForm<SaveButton: View>: View {
    @ObservedObject var presetViewModel: PresetViewModel

    @State var formDeckName: String
    @State var formPresetId: UUID
    
    var FormButton: (DeckForm) -> SaveButton
    
    var body: some View {
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
                FormButton(self)
            }
        }
        .listStyle(GroupedListStyle())
//        .listStyle(InsetGroupedListStyle())
    }
}
