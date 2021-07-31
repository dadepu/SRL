//
//  PresetView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct Presets: View {
    @ObservedObject private var presetViewModel = PresetViewModel()
    @ObservedObject private var deckViewModel: DeckViewModel
    
    @State private var isShowingNewPresetSheet: Bool = false
    
    
    init(deck: Deck) {
        deckViewModel = DeckViewModel(deck: deck)
    }
    
    var body: some View {
        List {
            Section(header: Text("Presets")) {
                ForEach(presetViewModel.orderedPresets) { (preset: SchedulePreset) in
                    NavigationLink(
                        destination: EditPreset(presetViewModel: presetViewModel, preset: preset),
                        label: {
                            Text(preset.name)
                        })
                }.onDelete(perform: presetViewModel.deletePresets)
            }
            Section {
                Button(action: {
                    isShowingNewPresetSheet = true
                }, label: {
                    Text("New Preset")
                })
            }
        }
        .listStyle(GroupedListStyle())
        .sheet(isPresented: $isShowingNewPresetSheet, content: {
            NewPreset(isShowingSheet: $isShowingNewPresetSheet)
        })
        .navigationBarTitle("Presets", displayMode: .inline)
    }
}
