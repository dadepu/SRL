//
//  DeckApiService.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

final class DeckApiService: ObservableObject {
    @Published private (set) var decks: [UUID: Deck] = [UUID: Deck]()
    private var dataSaving: AnyCancellable?
    
    static let userdefaultsDeckKey = "DeckApiService.decks"
    
    
    init() {
        if let decksLoaded = loadData() {
            decks = decksLoaded
        }
        dataSaving = $decks.sink(receiveValue: saveData)
    }
    
    
    func setDeck(with deck: Deck) {
        decks[deck.id] = deck
    }
    
    func withDeck(forID deckID: UUID) -> Deck? {
        decks[deckID]
    }
    
    @discardableResult
    func dropDeck(forID deckID: UUID) -> Deck? {
        decks.removeValue(forKey: deckID)
    }
    
    
    
    func loadData() -> [UUID:Deck]? {
        let jsonData = UserDefaults.standard.data(forKey: DeckApiService.userdefaultsDeckKey)
        if jsonData != nil, let decodedDecks = try? JSONDecoder().decode([UUID:Deck].self, from: jsonData!) {
            return decodedDecks
        } else {
            return nil
        }
    }
    
    func saveData(decks: [UUID:Deck]) {
        let decksJSON = try? JSONEncoder().encode(decks)
        UserDefaults.standard.set(decksJSON, forKey: DeckApiService.userdefaultsDeckKey)
    }
}
