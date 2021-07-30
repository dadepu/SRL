//
//  CardTypeMapper.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import Foundation

enum CardTypeMapper: String, Identifiable, CaseIterable {
    case Default
    
    
    var getAllowedContentTypesFront: [ContentTypeMapper] {
        get {
            switch (self) {
            case .Default:
                return [.Text, .Image]
            }
        }
    }
    
    var getAllowedContentTypesBack: [ContentTypeMapper] {
        get {
            switch (self) {
            case .Default:
                return [.Text, .Image]
            }
        }
    }
    
    var id: String { self.rawValue }
}
