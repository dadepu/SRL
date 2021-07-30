//
//  CardContentForm.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct CardContentForm<ActionButton: View>: View {
    @State var formSelectedContentType: ContentTypeMapper = .Text
    @State var formTextContent: String = ""
    @State var formImage: Image? = nil

    @State private var inputImage: UIImage?
    @State private var isShowingImagePicker: Bool = false
    
    
    var allowedContentTypes: [ContentTypeMapper]
    var FormButton: (CardContentForm) -> ActionButton
    
    var body: some View {
        List {
            Section(header: Text("Card Content")) {
                Picker(selection: $formSelectedContentType, label: Text("Type")) {
                    ForEach(allowedContentTypes) { contentType in
                        Text(contentType.rawValue)
                            .tag(contentType)
                    }
                }
                switch (formSelectedContentType) {
                case .Text:
                    TextContentView(formTextContent: $formTextContent)
                case .Image:
                    ImageContentView(formImage: $formImage, isShowingImagePicker: $isShowingImagePicker)
                }
            }
            Section {
                FormButton(self)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: self.$inputImage)
        })
        
    }
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        formImage = Image(uiImage: inputImage)
    }
    
    func validateContent() -> Bool {
        switch (formSelectedContentType) {
        case .Text:
            return !formTextContent.isEmpty
        case .Image:
            return formImage != nil && inputImage != nil
        }
    }
    
    func getCardContent() throws -> CardContentType {
        switch(formSelectedContentType) {
        case .Text:
            return CardContentType.TEXT(content: try TextContent.makeTextContent(text: formTextContent))
        case .Image:
            return CardContentType.IMAGE(content: try ImageContent.makeImageContent(image: inputImage!))
        }
    }
    
    struct TextContentView: View {
        @Binding var formTextContent: String
        
        var body: some View {
            TextEditor(text: $formTextContent)
                .lineSpacing(5)
        }
    }
    
    struct ImageContentView: View {
        @Binding var formImage: Image?
        @Binding var isShowingImagePicker: Bool
        
        var body: some View {
            VStack {
                if formImage != nil {
                    formImage!
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            self.isShowingImagePicker = true
                        }
                } else {
                    Button(action: {
                        self.isShowingImagePicker = true
                    }, label: {
                        Text("From Gallery")
                    })
                }
            }
        }
    }
}
