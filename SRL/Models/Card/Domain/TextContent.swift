//
//  TextContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct TextContent: Codable {
    private (set) var text: String
    
    
    private init(_ text: String) {
        self.text = text
    }
    
    static func makeTextContent(text: String) throws -> TextContent {
        guard !text.isEmpty else {
            throw CardContentException.IllegalArgument
        }
        return TextContent(text)
    }
}
