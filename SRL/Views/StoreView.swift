//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct StoreView: View {
    @ObservedObject var storeViewModel: StoreViewModel
    
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    @State private var formDeckName: String = ""
    @State private var formPresetIndex: Int = 0
    

    var body: some View {
        NavigationView {
            DeckListSection(storeViewModel: storeViewModel, decks: storeViewModel.decks)
            .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [.allowContentDrag, .swipeToDismiss, .tapToDissmiss],
                         headerContent: BottomSheetHeader, mainContent: BottomSheetContent)
            .navigationBarTitle("Decks", displayMode: .inline)
            .navigationBarItems(leading: ButtonAddDeck(bottomSheetPosition: $bottomSheetPosition))
        }
    }
    
    
    
    func BottomSheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Add Deck")
                .font(.title).bold()
            Divider()
        }
    }
    
    func BottomSheetContent() -> some View {
        VStack(spacing: 0) {
            List {
                TextField("Deck Name", text: $formDeckName)
                Picker(selection: $formPresetIndex, label: Text("Preset")) {
                    ForEach(0 ..< storeViewModel.presets.count) {
                        Text(self.storeViewModel.presets[$0].name)
                    }
                }
            }
            Button(action: createDeckAction, label: {
                Text("Create")
                    .bold()
            })
            Spacer()
        }
    }
    
    struct ButtonAddDeck: View {
        @Binding var bottomSheetPosition: BottomSheetPosition
        
        var body: some View {
            Button(action: {
                bottomSheetPosition = .middle
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            })
        }
    }
    
    func createDeckAction() {
        makeDeck(name: formDeckName, presetIndex: formPresetIndex)
        formDeckName = ""
        formPresetIndex = 0
        bottomSheetPosition = .hidden
    }
    
    func makeDeck(name: String, presetIndex: Int) {
        let presetId = storeViewModel.presets[presetIndex].id
        try? storeViewModel.makeDeck(name: name, presetId: presetId)
    }
}


//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StoreView(storeViewModel: StoreViewModel(DeckApiService()))
//        }
//    }
//}

