//
//  CardUserDefaultsRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 12.07.21.
//

import Foundation

struct CardUserDefaultsRepository {
    private static let userdefaultsDeckKey = "Card.RootAggregate"
    
    
    func loadCards() -> [UUID:Card]? {
        let jsonData = UserDefaults.standard.data(forKey: CardUserDefaultsRepository.userdefaultsDeckKey)
        if jsonData != nil, let decodedSchedulers = try? JSONDecoder().decode([UUID:Card].self, from: jsonData!) {
            return decodedSchedulers
        } else {
            return nil
        }
    }

    func saveCards(_ presets: [UUID:Card]) {
        let presetsJSON = try? JSONEncoder().encode(presets)
        UserDefaults.standard.set(presetsJSON, forKey: CardUserDefaultsRepository.userdefaultsDeckKey)
    }

    func deleteCards() {
        UserDefaults.standard.set("", forKey: CardUserDefaultsRepository.userdefaultsDeckKey)
    }
}
