//
//  PresetView.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct PresetView: View {
    @ObservedObject private var presetViewModel = PresetViewModel()
    @ObservedObject private var deckViewModel: DeckViewModel
    
    @State private var opacityBottomUpSheets: Double = 0
    @State private var isShowingAddPresetSheet: BottomSheetPosition = .hidden
    
    
    init(deck: Deck) {
        deckViewModel = DeckViewModel(deck: deck)
    }
    
    var body: some View {
        List {
            Section(header: Text("Presets")) {
                ForEach(presetViewModel.presets) { (preset: SchedulePreset) in
                    NavigationLink(
                        destination: EditPresetView(preset: preset),
                        label: {
                            Text(preset.name)
                        })
                }
            }
            Section {
                Button(action: {
                    opacityBottomUpSheets = 1
                    isShowingAddPresetSheet = .top
                }, label: {
                    Text("Add Preset")
                })
            }
        }
        .listStyle(GroupedListStyle())
        .modifier(AddPresetSheet(isShowingBottomSheet: $isShowingAddPresetSheet, opacityBottomSheet: $opacityBottomUpSheets))
        .navigationBarTitle("Presets", displayMode: .inline)
    }
}
