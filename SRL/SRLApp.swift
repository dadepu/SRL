//
//  SRLApp.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import SwiftUI

@main
struct SRLApp: App {
    
    @ObservedObject private var presetViewModel: PresetViewModel = PresetViewModel()
    @ObservedObject private var storeViewModel: StoreViewModel = StoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            DeckListView(presetViewModel: presetViewModel, storeViewModel: storeViewModel)
                .environmentObject(storeViewModel)
        }
    }
}
