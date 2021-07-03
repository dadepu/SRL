//
//  DeckUserDefaultsRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct DeckUserDefaultsRepository {
    private static let userdefaultsDeckKey = "CardDeck.RootAggregate"
    
    
    func loadPresets() -> [UUID:Deck]? {
        let jsonData = UserDefaults.standard.data(forKey: DeckUserDefaultsRepository.userdefaultsDeckKey)
        if jsonData != nil, let decodedDecks = try? JSONDecoder().decode([UUID:Deck].self, from: jsonData!) {
            return decodedDecks
        } else {
            return nil
        }
    }

    func savePresets(_ presets: [UUID:Deck]) {
        let presetsJSON = try? JSONEncoder().encode(presets)
        UserDefaults.standard.set(presetsJSON, forKey: DeckUserDefaultsRepository.userdefaultsDeckKey)
    }

    func deletePresets() {
        UserDefaults.standard.set("", forKey: DeckUserDefaultsRepository.userdefaultsDeckKey)
    }
}
