//
//  CardContentText.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct SheetCardContentText: View {
    @Binding var validContent: Bool
    @Binding var formTextContent: String
    
    
    var body: some View {
        TextEditor(text: $formTextContent)
            .lineSpacing(5)
            .onChange(of: formTextContent, perform: { value in
                validateContent(text: value)
            })
    }
    
    private func validateContent(text: String) {
        validContent = !text.isEmpty
    }
    
    static func getContent(text: String) -> CardContentType {
        CardContentType.TEXT(content: try! TextContent.makeTextContent(text: text))
    }
}
