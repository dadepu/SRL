//
//  CardContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import Foundation

struct CardContentTypeContainer: Identifiable, Codable {
    private (set) var id: UUID = UUID()
    private (set) var content: CardContentType
    
    init(_ content: CardContentType) {
        self.content = content
    }
}
