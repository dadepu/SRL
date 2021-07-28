//
//  StoreView.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import SwiftUI

struct StoreView: View {
    @ObservedObject private var presetViewModel: PresetViewModel = PresetViewModel()
    @ObservedObject private var storeViewModel: StoreViewModel = StoreViewModel()
    
    @State private var isShowingBottomSheetAddDeck: BottomSheetPosition = .hidden
    @State private var opacityBottomUpSheets: Double = 0
    @State private var formDeckName: String = ""
    @State private var formPresetIndex: Int = 0

    

    var body: some View {
        NavigationView {
            DeckListSection(storeViewModel: storeViewModel, presetViewModel: presetViewModel)
            .modifier(AddDeckSheet(presetViewModel: presetViewModel, storeViewModel: storeViewModel, isShowingBottomSheet: $isShowingBottomSheetAddDeck,opacityBottomSheet: $opacityBottomUpSheets , formDeckName: $formDeckName, formPresetIndex: $formPresetIndex))
            .navigationBarTitle("Decks", displayMode: .inline)
            .navigationBarItems(leading: NavButtonAddDeck(bottomSheetPosition: $isShowingBottomSheetAddDeck, bottomSheetOpacity: $opacityBottomUpSheets))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    struct NavButtonAddDeck: View {
        @Binding var bottomSheetPosition: BottomSheetPosition
        @Binding var bottomSheetOpacity: Double
        
        var body: some View {
            Button(action: {
                bottomSheetOpacity = 1
                bottomSheetPosition = .middle
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            })
        }
    }
}










//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StoreView(storeViewModel: StoreViewModel(DeckApiService()))
//        }
//    }
//}

