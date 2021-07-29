//
//  ImageContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 03.07.21.
//

import Foundation
import SwiftUI

struct ImageContent: Codable {
    private var imageContainer: ImageEncoder
    
    
    private init(_ imageContainer: ImageEncoder) {
        self.imageContainer = imageContainer
    }
    
    static func makeImageContent(image: UIImage) throws -> ImageContent {
        let imageWrapper = try ImageEncoder(image: image)
        return ImageContent(imageWrapper)
    }
    
    func getImage() throws -> UIImage {
        try imageContainer.getImage()
    }
}
