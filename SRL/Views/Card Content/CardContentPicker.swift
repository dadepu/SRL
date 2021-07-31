//
//  CardContentPicker.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct CardContentPicker: View {
    @Binding var isShowing: Bool
    @Binding var cardType: CardTypeMapper
    
    var allowedContentTypes: [ContentTypeMapper]
    var saveAction: (CardContentType) -> Bool
    var navHeading: () -> String
    
    var body: some View {
        Group {
        }.sheet(isPresented: $isShowing, content: {
            NavigationView {
                CardContentForm(allowedContentTypes: allowedContentTypes, FormButton: { cardContentForm in
                    SaveButton(isShowing: $isShowing, cardContentForm: cardContentForm, saveAction: saveAction)
                })
                .navigationBarTitle(Text(navHeading()))
            }
        })
    }
    
    
    struct SaveButton: View {
        @Binding var isShowing: Bool
        
        var cardContentForm: CardContentForm<SaveButton>
        var saveAction: (CardContentType) -> Bool
        
        var body: some View {
            Button(action: {
                guard cardContentForm.validateContent(), let cardContent = try? cardContentForm.getCardContent() else { return }
                let saveResponse = saveAction(cardContent)
                guard saveResponse else { return }
                isShowing = false
            }, label: {
                HStack {
//                    Spacer()
                    Text("Save")
                        .bold()
//                    Spacer()
                }
            })
            .disabled(!cardContentForm.validateContent())
        }
    }
}
