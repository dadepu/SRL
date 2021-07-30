//
//  NewCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct NewCard: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var createCardViewModel: CreateCardViewModel
    
    @State private (set) var isShowingContentFront: Bool = false
    @State private (set) var isShowingContentBack: Bool = false
    
    @State private (set) var cardType: CardTypeMapper = .Default
    
    init(deckViewModel: DeckViewModel, presetViewModel: PresetViewModel) {
        self.deckViewModel = deckViewModel
        self.presetViewModel = presetViewModel
        self.createCardViewModel = CreateCardViewModel(deck: deckViewModel.deck)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Settings")){
                CardTypePicker(createCardViewModel: createCardViewModel, cardType: $cardType)
                CardSchedulePresetPicker(presetViewModel: presetViewModel, abstractCardViewModel: createCardViewModel, presetId: deckViewModel.deck.schedulePreset.id)
            }
            Section(header: Text("Front")){
                CardFormContentListing(abstractCardViewModel: createCardViewModel, isShowingModal: $isShowingContentFront, cardContent: createCardViewModel.frontCardContent, onMoveAction: createCardViewModel.moveFrontContent, onDeleteAction: createCardViewModel.deleteFrontContent)
            }
            Section(header: Text("Back")) {
                CardFormContentListing(abstractCardViewModel: createCardViewModel, isShowingModal: $isShowingContentBack, cardContent: createCardViewModel.backCardContent, onMoveAction: createCardViewModel.moveBackContent, onDeleteAction: createCardViewModel.deleteBackContent)
            }
            Section {
                Button("Save Card") {
                    createCardViewModel.saveAsCard()
                }
                .disabled(!createCardViewModel.cardIsSaveable)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
        CardContentPicker(isShowing: $isShowingContentFront, cardType: $cardType, allowedContentTypes: cardType.getAllowedContentTypesFront, saveAction: { cardContentType in
                createCardViewModel.addFrontContent(cardContentType)
                return true
            }, navHeading: { "Front" })
        CardContentPicker(isShowing: $isShowingContentBack, cardType: $cardType, allowedContentTypes: cardType.getAllowedContentTypesBack, saveAction: { cardContentType in
                createCardViewModel.addBackContent(cardContentType)
                return true
            }, navHeading: { "Back" })
    }
}
