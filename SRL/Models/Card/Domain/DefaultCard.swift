//
//  DefaultContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct DefaultCard: Codable {
    private (set) var questionContent: [CardContentTypeContainer]
    private (set) var answerContent: [CardContentTypeContainer]
    private (set) var hint: TextContent?
    
    
    init(questions: [CardContentTypeContainer], answers: [CardContentTypeContainer], hint: TextContent?) {
        self.questionContent = questions
        self.answerContent = answers
        self.hint = hint
    }
}
