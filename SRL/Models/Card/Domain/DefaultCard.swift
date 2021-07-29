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
    
    static func makeDefaultCard(questions: [CardContentTypeContainer], answers: [CardContentTypeContainer], hint: TextContent? = nil) throws -> DefaultCard {
        let _ = try validateContainingCardContentTypes(content: questions)
        let _ = try validateContainingCardContentTypes(content: answers)
        return DefaultCard(questions: questions, answers: answers, hint: hint)
    }
    
    private static func validateContainingCardContentTypes(content: [CardContentTypeContainer]) throws -> Bool {
        for cardContentContainer in content {
            guard isPermittedType(cardContent: cardContentContainer.content) else {
                throw CardTypeException.ContainsInvalidCardContentType
            }
        }
        return true
    }
    
    private static func isPermittedType(cardContent: CardContentType) -> Bool {
        switch (cardContent) {
            case .TEXT(_): return true
            case .IMAGE(_): return true
            case .TYPING(_): return false
        }
    }
}
