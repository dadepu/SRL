//
//  ImageWrapper.swift
//  SRL
//
//  Created by Daniel Koellgen on 26.07.21.
//

import Foundation
import SwiftUI

public struct ImageEncoder: Codable {
    private var encodedImage: Data
    
    init(image: UIImage) throws {
        guard let encodedImage = image.pngData() else {
            throw ImageEncoderException.EncodingError
        }
        self.encodedImage = encodedImage
    }
    
    func getImage() throws -> UIImage {
        guard let decodedImage = UIImage(data: encodedImage) else {
            throw ImageEncoderException.DecodingError
        }
        return decodedImage
    }
}

enum ImageEncoderException: Error {
    case EncodingError
    case DecodingError
}
