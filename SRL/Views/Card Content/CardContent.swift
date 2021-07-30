//
//  CardContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardContent: View {
    var cardContent: CardContentTypeContainer
    
    var body: some View {
        switch (cardContent.content) {
            case .TEXT(let content):
                Text(content.text)
            case .IMAGE(let content):
                Image(uiImage: try! content.getImage())
                    .resizable()
                    .scaledToFit()
            default:
                EmptyView()
        }
    }
}
