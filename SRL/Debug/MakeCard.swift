//
//  MakeCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.07.21.
//

import Foundation

struct MakeCard {
    
    func generateRandomDefaultCardContent() -> CardType {
        let textContentQuestion1 = try! TextContent.makeTextContentFromString(text: "UnitTest \(UUID())")
        let textContentQuestion1CardContentType = CardContentType.TEXT(content: textContentQuestion1)
        
        let textContentAnswer1 = try! TextContent.makeTextContentFromString(text: "UnitTest Answer")
        let textContentAnswer1CardContentType = CardContentType.TEXT(content: textContentAnswer1)
        
        let defaultCard = try! DefaultCard.makeDefaultCard(questions: [CardContentTypeContainer(textContentQuestion1CardContentType)], answers: [CardContentTypeContainer(textContentAnswer1CardContentType)], hint: nil)
        return CardType.DEFAULT(content: defaultCard)
    }
    
    func generateRandomDefaultCard() -> Card {
        let scheduler = Scheduler(schedulePreset: SchedulePresetService().getDefaultSchedulePreset())
        return Card(content: generateRandomDefaultCardContent(), scheduler: scheduler)
    }
}
