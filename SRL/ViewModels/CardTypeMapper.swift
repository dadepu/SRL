//
//  CardTypeMapper.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import Foundation

enum CardTypeMapper: String, Identifiable, CaseIterable {
    case Default
//    case Typing
    
    var id: String { self.rawValue }
}
