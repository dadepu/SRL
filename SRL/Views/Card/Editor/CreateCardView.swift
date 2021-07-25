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
            Text("ViewModel ID: \(createCardViewModel.id)")
            Section(header: Text("Settings")){
                CardTypePicker(createCardViewModel: createCardViewModel, cardType: $formCardType)
                SchedulePresetPicker(presetViewModel: presetViewModel, createCardViewModel: createCardViewModel, presetIndex: $formPresetIndex)
            }
            Section(header: Text("Front")){
                FrontCardContent(createCardViewModel: createCardViewModel)
                FrontCardAddContentButton(isShowing: $isShowingBottomSheetAddContentFront, opacity: $opacityBottomUpSheets)
            }
            Section(header: Text("Back")){
                BackCardContent(createCardViewModel: createCardViewModel)
                BackCardAddContentButton(isShowing: $isShowingBottomSheetAddContentBack, opacity: $opacityBottomUpSheets)
            }
            Section {
                SaveCardButton(createCardViewModel: createCardViewModel)
            }
        }
        .listStyle(GroupedListStyle())
        .modifier(CardFrontContentSheet(createCardViewModel: createCardViewModel, isShowingBottomSheet: $isShowingBottomSheetAddContentFront, opacityBottomSheet: $opacityBottomUpSheets))
        .modifier(CardBackContentSheet(createCardViewModel: createCardViewModel, cardType: $formCardType, isShowingBottomSheet: $isShowingBottomSheetAddContentBack, opacityBottomSheet: $opacityBottomUpSheets))
        .navigationBarTitle(deckViewModel.deck.name, displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
    
    
    private struct SchedulePresetPicker: View {
        @ObservedObject var presetViewModel: PresetViewModel
        @ObservedObject var createCardViewModel: CreateCardViewModel
        @Binding var presetIndex: Int
        
        var body: some View {
            Picker(selection: $presetIndex, label: Text("Scheduler Preset")) {
                ForEach(0 ..< presetViewModel.presets.count) {
                    Text(self.presetViewModel.presets[$0].name)
                }
            }.onChange(of: presetIndex, perform: { (value: Int) in
                if let preset = presetViewModel.getPreset(forIndex: value) {
                    createCardViewModel.changeSchedulePreset(presetId: preset.id)
                }
            })
        }
    }
    
    private struct CardTypePicker: View {
        @ObservedObject var createCardViewModel: CreateCardViewModel
        @Binding var cardType: CardTypeMapper
        
        var body: some View {
            Picker(selection: $cardType, label: Text("Card Type")) {
                ForEach(CardTypeMapper.allCases) { cardType in
                    Text(cardType.rawValue)
                        .tag(cardType)
                }
            }.onChange(of: cardType, perform: { (type: CardTypeMapper) in
                createCardViewModel.changeCardType(cardType: type)
            })
        }
    }
    
    private struct FrontCardContent: View {
        @ObservedObject var createCardViewModel: CreateCardViewModel
        
        var body: some View {
            ForEach(createCardViewModel.frontCardContent) { (cardContent: CardContentTypeContainer)  in
                CardContent(cardContent: cardContent)
            }
            .onMove(perform: createCardViewModel.moveFrontContent)
            .onDelete(perform: createCardViewModel.deleteFrontContent)
        }
    }
    
    private struct FrontCardAddContentButton: View {
        @Binding var isShowing: BottomSheetPosition
        @Binding var opacity: Double
        
        var body: some View {
            Button("Add Content") {
                opacity = 1
                isShowing = .top
            }
        }
    }
    
    private struct BackCardContent: View {
        @ObservedObject var createCardViewModel: CreateCardViewModel
        
        var body: some View {
            ForEach(createCardViewModel.backCardContent) { (cardContent: CardContentTypeContainer)  in
                CardContent(cardContent: cardContent)
            }
            .onMove(perform: createCardViewModel.moveBackContent)
            .onDelete(perform: createCardViewModel.deleteBackContent)
        }
    }
    
    private struct BackCardAddContentButton: View {
        @Binding var isShowing: BottomSheetPosition
        @Binding var opacity: Double
        
        var body: some View {
            Button("Add Content") {
                opacity = 1
                isShowing = .top
            }
        }
    }
    
    private struct SaveCardButton: View {
        @ObservedObject var createCardViewModel: CreateCardViewModel
        
        var body: some View {
            Button("Save Card") {
                createCardViewModel.saveAsCard()
            }
            .disabled(!createCardViewModel.cardIsSaveable)
        }
    }
}


