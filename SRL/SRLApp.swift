//
//  SRLApp.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import SwiftUI

@main
struct SRLApp: App {
    @State var deckApi: DeckApiService = DeckApiService()
    
    var body: some Scene {
        WindowGroup {
            StoreView(storeViewModel: StoreViewModel(DeckApiService()))
        }
    }
}
