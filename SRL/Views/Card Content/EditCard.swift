//
//  EditCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct EditCard: View {
    @ObservedObject private var storeViewModel: StoreViewModel
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var editCardViewModel: EditCardViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private (set) var isShowingContentFront: Bool = false
    @State private (set) var isShowingContentBack: Bool = false
    
    @State private (set) var cardType: CardTypeMapper = .Default
    
    
    init(deckViewModel: DeckViewModel, presetViewModel: PresetViewModel, deck: Deck, card: Card) {
        self.storeViewModel = StoreViewModel()
        self.deckViewModel = deckViewModel
        self.presetViewModel = presetViewModel
        self.editCardViewModel = EditCardViewModel(deck: deck, card: card)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Scheduling")) {
                ListRowHorizontalSeparated(textLeft: {"Learning State"}, textRight: {editCardViewModel.card.scheduler.learningState.status})
                ListRowHorizontalSeparated(textLeft: {"Review Count"}, textRight: {"\(editCardViewModel.card.scheduler.reviewCount)"})
                ListRowHorizontalSeparated(textLeft: {"Current Interval"}, textRight: {editCardViewModel.card.scheduler.currentReviewInterval.getFormatted()})
                ListRowHorizontalSeparated(textLeft: {"Next Review"}, textRight: {editCardViewModel.card.scheduler.nextReviewDate.getFormatted(dateFormat: "dd.MM.yyyy (hh:mm)")})
                ListRowHorizontalSeparated(textLeft: {"Ease Factor"}, textRight: {editCardViewModel.card.scheduler.easeFactor.toString()})
                Button(action: {editCardViewModel.graduateScheduler()}, label: {
                    Text("Graduate Scheduler")
                }).disabled(!editCardViewModel.card.scheduler.isGraduateable)
                Button(action: {editCardViewModel.resetCard()}, label: {
                    Text("Reset Scheduler")
                })
            }
            Section(header: Text("Settings")) {
                ListRowHorizontalSeparated(textLeft: {"Card Type"}, textRight: {editCardViewModel.cardType.rawValue})
                CardSchedulePresetPicker(presetViewModel: presetViewModel, abstractCardViewModel: editCardViewModel, presetId: editCardViewModel.card.scheduler.schedulePreset.id)
                CardDeckPicker(storeViewModel: storeViewModel, editCardViewModel: editCardViewModel, deckIndex: editCardViewModel.changedDeckId != nil ? editCardViewModel.changedDeckId! : editCardViewModel.deck.id)
            }
            Section(header: Text("Front")){
                CardFormContentListing(abstractCardViewModel: editCardViewModel, isShowingModal: $isShowingContentFront, cardContent: editCardViewModel.frontCardContent, onMoveAction: editCardViewModel.moveFrontContent, onDeleteAction: editCardViewModel.deleteFrontContent)
            }
            Section(header: Text("Back")) {
                CardFormContentListing(abstractCardViewModel: editCardViewModel, isShowingModal: $isShowingContentBack, cardContent: editCardViewModel.backCardContent, onMoveAction: editCardViewModel.moveBackContent, onDeleteAction: editCardViewModel.deleteBackContent)
            }
            Section {
                Button("Save Changes") {
                    editCardViewModel.saveCardChanges()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(!editCardViewModel.cardIsSaveable)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Edit Card", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
        CardContentPicker(isShowing: $isShowingContentFront, cardType: $cardType, allowedContentTypes: cardType.getAllowedContentTypesFront, saveAction: { cardContentType in
                editCardViewModel.addFrontContent(cardContentType)
                return true
            }, navHeading: { "Front" })
        CardContentPicker(isShowing: $isShowingContentBack, cardType: $cardType, allowedContentTypes: cardType.getAllowedContentTypesBack, saveAction: { cardContentType in
                editCardViewModel.addBackContent(cardContentType)
                return true
            }, navHeading: { "Back" })
    }
}
