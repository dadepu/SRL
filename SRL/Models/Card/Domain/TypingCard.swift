//
//  TypingContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct TypingCard: Codable {
    private (set) var questionContent: [CardContentType]
    private (set) var answerContent: TypingContent
    
    
    init(questions: [CardContentType], answers: TypingContent) {
        self.questionContent = questions
        self.answerContent = answers
    }
    
    func validateAnswer(input: String) -> Bool {
        // TODO
        return false
    }
}
