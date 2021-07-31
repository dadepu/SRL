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
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
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
                    ImageContentView(inputImage: $inputImage, formImage: $formImage, imagePickerSourceType: $imagePickerSourceType, isShowingImagePicker: $isShowingImagePicker)
                }
                
            }
            .onChange(of: inputImage, perform: { value in
                if inputImage != nil {
                    formImage = Image(uiImage: inputImage!)
                }
            })
            Section {
                FormButton(self)
            }
        }
        .listStyle(GroupedListStyle())
        .sheet(isPresented: $isShowingImagePicker, content: { ImagePicker(image: self.$inputImage, sourceType: imagePickerSourceType) })
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
    
    private struct TextContentView: View {
        @Binding var formTextContent: String
        
        var body: some View {
            TextEditor(text: $formTextContent)
                .lineSpacing(5)
        }
    }
    
    private struct ImageContentView: View {
        @Binding var inputImage: UIImage?
        @Binding var formImage: Image?
        @Binding var imagePickerSourceType: UIImagePickerController.SourceType
        @Binding var isShowingImagePicker: Bool
        @State private var pasteboard = UIPasteboard.general
        @State private var alertShowing: Bool = false
        
        var body: some View {
            if formImage != nil {
                formImage!
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        self.isShowingImagePicker = true
                    }
            }
            Button(action: {
                imagePickerSourceType = .photoLibrary
                isShowingImagePicker = true
            }, label: {
                Text("From Gallery")
            })
            Button(action: loadImageFromPasteboard, label: {
                Text("From Pasteboard")
            })
            Button(action: {
                imagePickerSourceType = .camera
                isShowingImagePicker = true
            }, label: {
                Text("From Camera")
            })
            .alert(isPresented:$alertShowing) {
                Alert(
                    title: Text("No Image found"),
                    message: Text("To paste an image from your pasteboard, you have to copy an image in the first place."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
        private func loadImageFromPasteboard() {
            if pasteboard.hasImages {
                inputImage = pasteboard.image
            } else {
                alertShowing = true
            }
        }
    }
}
