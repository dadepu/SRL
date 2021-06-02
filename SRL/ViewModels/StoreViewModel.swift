//
//  StoreViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import Foundation

class StoreViewModel: ObservableObject {
    @Published private (set) var deckServiceApi: DeckApiService
    
    init(deckService: DeckApiService) {
        deckServiceApi = deckService
    }
    
//    func createNewDeck(name: String) {
//        deckServiceApi.createDeck(deckName: name)
//    }
//    
//    func renameDeck(id: UUID, name: String) {
//        
//    }
//    
//    func removeDeck(id: UUID) {
//        
//    }
}
