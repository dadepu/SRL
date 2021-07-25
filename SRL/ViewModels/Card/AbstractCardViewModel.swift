//
//  CardViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import Foundation
import Combine

class AbstractCardViewModel: ObservableObject {
    private (set) var id = UUID()
    @Published var cardType: CardTypeMapper = .Default
    @Published var schedulePreset: SchedulePreset
    @Published var frontCardContent: [CardContentTypeContainer] = []
    @Published var backCardContent: [CardContentTypeContainer] = []
    @Published var cardIsSaveable: Bool = false
               var deck: Deck
    
    var frontContentObserver: AnyCancellable?
    var backContentObserver: AnyCancellable?
    
    
    
    
    init(deck: Deck) {
        self.deck = deck
        self.schedulePreset = SchedulePresetService().getDefaultSchedulePreset()
        self.frontContentObserver = self.$frontCardContent.sink { (front: [CardContentTypeContainer]) in
            self.cardIsSaveable = self.validateCardIsSaveable(front: front, back: self.backCardContent)
        }
        self.backContentObserver = self.$backCardContent.sink { (back: [CardContentTypeContainer]) in
            self.cardIsSaveable = self.validateCardIsSaveable(front: self.frontCardContent, back: back)
        }
    }
    
    private func validateCardIsSaveable(front: [CardContentTypeContainer], back: [CardContentTypeContainer]) -> Bool {
        front.count > 0 && back.count > 0
    }
    
    
    
    func changeSchedulePreset(presetId id: UUID) {
        schedulePreset = SchedulePresetService().getSchedulePresetOrDefault(forId: id)
    }
    
    func addFrontContent(_ content: CardContentType) {
        frontCardContent.append(CardContentTypeContainer(content))
    }
    
    func moveFrontContent(from source: IndexSet, to destination: Int) {
        frontCardContent.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteFrontContent(at offset: IndexSet) {
        frontCardContent.remove(atOffsets: offset)
    }
    
    func addBackContent(_ content: CardContentType) {
        backCardContent.append(CardContentTypeContainer(content))
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
