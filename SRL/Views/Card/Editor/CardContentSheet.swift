//
//  CardContentSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardContentSheet: ViewModifier {
    @ObservedObject var createCardViewModel: AbstractCardViewModel
    
    @Binding var isShowingSheet: BottomSheetPosition
    @Binding var opacitySheet: Double
    
    @State var allowedContentTypes: [ContentTypeMapper]
    @State var currentContentType: ContentTypeMapper = .Text
    @State var saveAllowed: Bool = false
    
    @State var formTextContent: String = ""
    
    var saveAction: (CardContentType, AbstractCardViewModel) -> ()
    
    
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingSheet, options: [.swipeToDismiss, .tapToDissmiss, .noBottomPosition], headerContent: SheetHeader, mainContent: SheetContent, opacity: $opacitySheet)
    }
    
    private func SheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Front")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func SheetContent() -> some View {
        VStack {
            List {
                Section {
                    ContentTypePicker(allowedContentTypes: $allowedContentTypes, currentContentType: $currentContentType)
                    ContentType(contentType: $currentContentType, saveAllowed: $saveAllowed, formTextContent: $formTextContent)
                }
                Section {
                    ButtonSaveContent(saveAllowed: $saveAllowed, buttonAction: saveContentButtonPressAction)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    
    
    private struct ContentTypePicker: View {
        @Binding var allowedContentTypes: [ContentTypeMapper]
        @Binding var currentContentType: ContentTypeMapper
        
        var body: some View {
            Picker(selection: $currentContentType, label: Text("Type")) {
                ForEach(allowedContentTypes) { contentType in
                    Text(contentType.rawValue)
                        .tag(contentType)
                }
            }
        }
    }
    
    private struct ContentType: View {
        @Binding var contentType: ContentTypeMapper
        @Binding var saveAllowed: Bool
        @Binding var formTextContent: String
        
        var body: some View {
            switch (contentType) {
                case .Text: SheetCardContentText(validContent: $saveAllowed, formTextContent: $formTextContent)
                case .Image: EmptyView()
            }
        }
    }
    
    private struct ButtonSaveContent: View {
        @Binding var saveAllowed: Bool
        var buttonAction: () -> ()
        
        var body: some View {
            Button(action: buttonAction, label: {
                HStack {
                    Spacer()
                    Text("Save")
                        .bold()
                    Spacer()
                }
            }).disabled(!saveAllowed)
        }
    }
    
    private func saveContentButtonPressAction() {
        saveContentToCard()
        resetContentSheet()
    }
    
    private func saveContentToCard() {
        switch (currentContentType) {
            case .Text:
                let cardContentType = SheetCardContentText.getContent(text: formTextContent)
                saveAction(cardContentType, createCardViewModel)
            default:
                {}()
        }
    }
    
    private func resetContentSheet() {
        isShowingSheet = .hidden
        formTextContent = ""
    }
}
