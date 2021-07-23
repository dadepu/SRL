//
//  ImageContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation

struct ImageContent: Codable {
    
    private init() {
        
    }
    
    static func makeImageContent() throws -> ImageContent {
        return ImageContent()
    }
}
