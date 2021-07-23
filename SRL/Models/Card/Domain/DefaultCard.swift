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
    
    
    private init(questions: [CardContentTypeContainer], answers: [CardContentTypeContainer], hint: TextContent?) {
        self.questionContent = questions
        self.answerContent = answers
        self.hint = hint
    }
    
    
    
    static func makeDefaultCard(questions: [CardContentTypeContainer], answers: [CardContentTypeContainer], hint: TextContent?) throws -> DefaultCard {
        if try validate(content: questions), try validate(content: answers) {
            return DefaultCard(questions: questions, answers: answers, hint: hint)
        }
        throw CardTypeException.containsInvalidCardContentType
    }
    
    private static func validate(content: [CardContentTypeContainer]) throws -> Bool {
        for cardContentContainer in content {
            if !validate(cardContent: cardContentContainer.content) {
                throw CardTypeException.containsInvalidCardContentType
            }
        }
        return true
    }
    
    private static func validate(cardContent: CardContentType) -> Bool {
        switch (cardContent) {
            case .TEXT(_): return true
            case .IMAGE(_): return true
            case .TYPING(_): return false
        }
    }
}
