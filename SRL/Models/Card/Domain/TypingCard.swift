//
//  TypingContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct TypingCard: Codable {
    private (set) var questionContent: [CardContentTypeContainer]
    private (set) var answerContent: CardContentTypeContainer
    
    
    init(questions: [CardContentTypeContainer], answers: CardContentTypeContainer) {
        self.questionContent = questions
        self.answerContent = answers
    }
    
    func validateAnswer(input: String) -> Bool {
        // TODO
        return false
    }
}
