//
//  CardEditorView.swift
//  SRL
//
//  Created by Daniel Koellgen on 22.07.21.
//

import SwiftUI

struct CreateCardView: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var createCardViewModel: CreateCardViewModel
    
    @State private var isShowingBottomSheetAddContentFront: BottomSheetPosition = .hidden
    @State private var isShowingBottomSheetAddContentBack: BottomSheetPosition = .hidden
    @State private var opacityBottomUpSheets: Double = 0
    
    
    @State private var formPresetIndex: Int = 0
    @State private var formCardType: CardTypeMapper = .Default
    @State private var isSaveableCard: Bool = false
    
    
    init(deckViewModel: DeckViewModel, presetViewModel: PresetViewModel) {
        self.deckViewModel = deckViewModel
        self.presetViewModel = presetViewModel
        self.createCardViewModel = CreateCardViewModel(deck: deckViewModel.deck)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Settings")){
                Picker(selection: $formPresetIndex, label: Text("Scheduler Preset")) {
                    ForEach(0 ..< presetViewModel.presets.count) {
                        Text(self.presetViewModel.presets[$0].name)
                    }
                }.onChange(of: formPresetIndex, perform: { (value: Int) in
                    if let preset = presetViewModel.getPreset(forIndex: value) {
                        createCardViewModel.changeSchedulePreset(presetId: preset.id)
                    }
                })
                Picker(selection: $formCardType, label: Text("Card Type")) {
                    ForEach(CardTypeMapper.allCases) { cardType in
                        Text(cardType.rawValue)
                            .tag(cardType)
                    }
                }.onChange(of: formCardType, perform: { (type: CardTypeMapper) in
                    createCardViewModel.changeCardType(cardType: type)
                })
            }
            Section(header: Text("Front")){
                ForEach(createCardViewModel.frontCardContent) { (cardContent: CardContentTypeContainer)  in
                    switch (cardContent.content) {
                        case .TEXT(let content): Text(content.text)
                        case .IMAGE(_): Text("IMAGE")
                        case .TYPING(_): EmptyView()
                    }
                }
                .onMove(perform: createCardViewModel.moveFrontContent)
                .onDelete(perform: createCardViewModel.deleteFrontContent)
                Button("Add Content") {
                    opacityBottomUpSheets = 1
                    isShowingBottomSheetAddContentFront = .top
                }
            }
            Section(header: Text("Back")){
                ForEach(createCardViewModel.backCardContent) { (cardContent: CardContentTypeContainer)  in
                    switch (cardContent.content) {
                        case .TEXT(let content): Text(content.text)
                        case .IMAGE(_): Text("IMAGE")
                        case .TYPING(_): EmptyView()
                    }
                }
                .onMove(perform: createCardViewModel.moveBackContent)
                .onDelete(perform: createCardViewModel.deleteBackContent)
                Button("Add Content") {
                    opacityBottomUpSheets = 1
                    isShowingBottomSheetAddContentBack = .top
                }
            }
            Section {
                Button("Save Card") {
                    createCardViewModel.saveAsCard()
                }
                .disabled(!createCardViewModel.cardIsSaveable)
            }
        }
        .listStyle(GroupedListStyle())
        // Front
        .modifier(CardContentSheet(createCardViewModel: createCardViewModel, isShowingBottomSheet: $isShowingBottomSheetAddContentFront, opacityBottomSheet: $opacityBottomUpSheets, allowedContentTypes: getAvailableTypesForFront(), callbackAction: appendContentToFront))
        // Back
        .modifier(CardContentSheet(createCardViewModel: createCardViewModel, isShowingBottomSheet: $isShowingBottomSheetAddContentBack, opacityBottomSheet: $opacityBottomUpSheets, allowedContentTypes: getAvailableTypesForBack(cardType: formCardType), callbackAction: appendContentToBack))
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
    
    
    
    private func getAvailableTypesForFront() -> [ContentTypeMapper] {
        [.Text, .Image]
    }
    
    private func getAvailableTypesForBack(cardType: CardTypeMapper) -> [ContentTypeMapper] {
        switch (cardType) {
            case .Default: return [.Text, .Image]
        }
    }
    
    private func appendContentToFront(content: CardContentType, cardViewModel: CreateCardViewModel) {
        cardViewModel.addFrontContent(content)
    }
    
    private func appendContentToBack(content: CardContentType, cardViewModel: CreateCardViewModel) {
        cardViewModel.addBackContent(content)
    }
}
