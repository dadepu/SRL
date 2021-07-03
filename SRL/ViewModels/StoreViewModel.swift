//
//  StoreViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.05.21.
//

import Foundation
import Combine

//class StoreViewModel: ObservableObject {
//    private (set) var deckServiceApi: DeckApiService
//    private (set) var listeningToDeckServiceApiCancellable: AnyCancellable?
//    
//    var decks: [Deck] {
//        get {
//            var deckArray: [Deck] = []
//            for (_, value) in deckServiceApi.decks {
//                deckArray.append(value)
//            }
//            return deckArray
//        }
//    }
//    
//    
//    
//    init(_ deckServiceApi: DeckApiService) {
//        self.deckServiceApi = deckServiceApi
//        listeningToDeckServiceApiCancellable = deckServiceApi.$decks.sink(receiveValue: refreshModel)
//    }
//    
//    func makeNewDeck(name: String) {
//        deckServiceApi.setDeck(with: Deck(name: name))
//    }
//    
//    func renameDeck(id: UUID, name: String) {
//        if let renamedDeck = deckServiceApi.withDeck(forID: id)?.renamedDeck(name: name) {
//            deckServiceApi.setDeck(with: renamedDeck)
//        }
//    }
//    
//    func removeDeck(id: UUID) {
//        deckServiceApi.dropDeck(forID: id)
//    }
//    
//    private func refreshModel(decks: [UUID: Deck]) {
//        self.objectWillChange.send()
//    }
//}
