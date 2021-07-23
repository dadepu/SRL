//
//  CardContentSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardContentSheet: ViewModifier {
    @ObservedObject var createCardViewModel: CreateCardViewModel
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var opacityBottomSheet: Double
    
    @State var allowedContentTypes: [ContentTypeMapper]
    @State var currentContentType: ContentTypeMapper = .Text
    @State var formText: String = ""
    
    var callbackAction: (CardContentType, CreateCardViewModel) -> ()
    
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.swipeToDismiss, .tapToDissmiss, .noBottomPosition], headerContent: sheetHeader, mainContent: sheetContent, opacity: $opacityBottomSheet)
    }
    
    private func sheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Front")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func sheetContent() -> some View {
        VStack {
            List {
                Section {
                    Picker(selection: $currentContentType, label: Text("Type")) {
                        ForEach(allowedContentTypes) { contentType in
                            Text(contentType.rawValue)
                                .tag(contentType)
                        }
                    }
                    TextEditor(text: $formText)
                        .lineSpacing(5)
                }
                Section {
                    Button(action: saveAction, label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .bold()
                            Spacer()
                        }
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    private func saveAction() {
        let cardContentType = CardContentType.TEXT(content: try! TextContent.makeTextContentFromString(text: formText))
//        createCardViewModel.addFrontContent(cardContentType)
        
        callbackAction(cardContentType, createCardViewModel)
        
        isShowingBottomSheet = .hidden
        formText = ""
    }
}
