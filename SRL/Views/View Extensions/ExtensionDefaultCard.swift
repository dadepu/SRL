//
//  ExtensionDefaultCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import Foundation

extension DefaultCard {
    var preview: String {
        switch (questionContent[0].content) {
        case .TEXT(let textContent):
            return textContent.text
        case .IMAGE(_):
            return "<Image>"
        default:
            return ""
        }
    }
}
