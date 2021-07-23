//
//  CardViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import Foundation
import Combine

class AbstractCardViewModel: ObservableObject {
    @Published var cardType: CardTypeMapper = .Default
    @Published var schedulePreset: SchedulePreset
    @Published var frontCardContent: [CardContentTypeContainer] = []
    @Published var backCardContent: [CardContentTypeContainer] = []
    
    var deck: Deck
    
    
    init(deck: Deck) {
        self.deck = deck
        self.schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
    }
    
    
    
    func changeSchedulePreset(presetId id: UUID) {
        schedulePreset = SchedulePresetService().getSchedulePresetOrDefault(forId: id)
    }
    
    func moveFrontContent(from source: IndexSet, to destination: Int) {
        frontCardContent.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteFrontContent(at offset: IndexSet) {
        frontCardContent.remove(atOffsets: offset)
    }
    
    func moveBackContent(from source: IndexSet, to destination: Int) {
        backCardContent.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteBackContent(at offset: IndexSet) {
        backCardContent.remove(atOffsets: offset)
    }
    
    func createCardType() throws -> CardType {
        switch (cardType) {
            case .Default:
                let defaultCardContent = try DefaultCard.makeDefaultCard(questions: frontCardContent, answers: backCardContent, hint: nil)
                return CardType.DEFAULT(content: defaultCardContent)
        }
    }
}
