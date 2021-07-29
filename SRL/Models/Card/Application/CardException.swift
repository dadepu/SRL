//
//  CardException.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import Foundation

enum CardException: Error {
    case EntityNotFound
}

enum CardTypeException: Error {
    case UnsupportedCardType
    case ContainsInvalidCardContentType
}

enum CardContentException: Error {
    case IllegalArgument
}
