//
//  ContentTypeMapper.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import Foundation

enum ContentTypeMapper: String, Identifiable, CaseIterable {
    case Text
    case Image
    
    var id: String { self.rawValue }
}
