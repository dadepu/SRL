//
//  DefaultContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct DefaultCard: Codable {
    private (set) var questionContent: [CardContentType]
    private (set) var answerContent: [CardContentType]
    private (set) var hint: TextContent?
    
    
    init(questions: [CardContentType], answers: [CardContentType], hint: TextContent?) {
        self.questionContent = questions
        self.answerContent = answers
        self.hint = hint
    }
}
