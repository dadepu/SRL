//
//  ExtensionEaseFactor.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

extension EaseFactor {
    
    func toString(format: String? = nil) -> String {
        let format = format != nil ? format! : "%.2f"
        return String(format: format, easeFactor)
    }
}
