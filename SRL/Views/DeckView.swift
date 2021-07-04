//
//  DeckView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel = PresetViewModel()
    
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    @State private var formDeckName: String = ""
    @State private var formPresetIndex: Int = 0
    
    
    init(deck: Deck) {
        self.deckViewModel = DeckViewModel(deck: deck)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Study")){
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        ListRowHorizontalSeparated(textLeft: {"Review"}, textRight: {"\(deckViewModel.deck.reviewQueue.reviewableCardCount)"})
                    })
                NavigationLink(
                    destination: CustomStudyView(deckViewModel: deckViewModel),
                    label: {
                        Text("Custom Study")
                    })
            }
            Section(header: Text("Actions")) {
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Add Cards")
                    })
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Text("Browse Cards")
                    })
            }
            Section(header: Text("Deck")) {
                Button("Presets") {
                    
                }
                Button("Edit") {
                    refreshEditDeckFormValues()
                    bottomSheetPosition = .middle
                }
                Button("Delete") {
                    
                }.foregroundColor(.red)
            }
        }
        .listStyle(GroupedListStyle())
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [.allowContentDrag, .swipeToDismiss, .tapToDissmiss],
                     headerContent: BottomSheetHeader, mainContent: BottomSheetContent)
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
    }
    
    
    func BottomSheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Edit Deck")
                .font(.title).bold()
            Divider()
        }
    }
    
    func BottomSheetContent() -> some View {
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
    
    func editDeckAction(deckName: String, presetIndex: Int) {
        deckViewModel.editDeck(name: deckName, presetIndex: presetIndex)
        bottomSheetPosition = .hidden
    }
    
    func refreshEditDeckFormValues() {
        formDeckName = deckViewModel.deck.name
        formPresetIndex = presetViewModel.getPresetIndexOrDefault(forId: deckViewModel.deck.schedulePreset.id)
    }
}



//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView()
//    }
//}
