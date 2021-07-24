//
//  EditCardView.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import SwiftUI

struct EditCardView: View {
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var editCardViewModel: EditCardViewModel
    
    @State private var isShowingBottomSheetAddContentFront: BottomSheetPosition = .hidden
    @State private var isShowingBottomSheetAddContentBack: BottomSheetPosition = .hidden
    @State private var opacityBottomUpSheets: Double = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var formPresetIndex: Int = 0
    @State private var formCardType: CardTypeMapper = .Default
    @State private var isSaveableCard: Bool = false
    
    
    init(deckViewModel: DeckViewModel, presetViewModel: PresetViewModel, deck: Deck, card: Card) {
        self.deckViewModel = deckViewModel
        self.presetViewModel = presetViewModel
        self.editCardViewModel = EditCardViewModel(deck: deck, card: card)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Statistics")) {
                ListRowHorizontalSeparated(textLeft: {"Learning State"}, textRight: {"\(editCardViewModel.card.scheduler.easeFactor)"})
                ListRowHorizontalSeparated(textLeft: {"Ease Factor"}, textRight: {"\(editCardViewModel.card.scheduler.easeFactor)"})
            }
            Section(header: Text("Settings")) {
                CardTypePicker(cardType: $formCardType)
                SchedulePresetPicker(presetViewModel: presetViewModel, editCardViewModel: editCardViewModel, presetIndex: $formPresetIndex)
            }
            Section(header: Text("Front")){
                FrontCardContent(editCardViewModel: editCardViewModel)
                FrontCardAddContentButton(isShowing: $isShowingBottomSheetAddContentFront, opacity: $opacityBottomUpSheets)
            }
            Section(header: Text("Back")) {
                BackCardContent(editCardViewModel: editCardViewModel)
                BackCardAddContentButton(isShowing: $isShowingBottomSheetAddContentBack, opacity: $opacityBottomUpSheets)
            }
            Section {
                SaveCardButton(editCardViewModel: editCardViewModel, presentationMode: presentationMode)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Edit Card", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
    
    
    private struct SchedulePresetPicker: View {
        @ObservedObject var presetViewModel: PresetViewModel
        @ObservedObject var editCardViewModel: EditCardViewModel
        @Binding var presetIndex: Int
        
        var body: some View {
            Picker(selection: $presetIndex, label: Text("Scheduler Preset")) {
                ForEach(0 ..< presetViewModel.presets.count) {
                    Text(self.presetViewModel.presets[$0].name)
                }
            }.onChange(of: presetIndex, perform: { (value: Int) in
                if let _ = presetViewModel.getPreset(forIndex: value) {
                    
                }
            })
        }
    }
    
    private struct CardTypePicker: View {
        @Binding var cardType: CardTypeMapper
        
        var body: some View {
            Picker(selection: $cardType, label: Text("Card Type")) {
                ForEach(CardTypeMapper.allCases) { cardType in
                    Text(cardType.rawValue)
                        .tag(cardType)
                }
            }.disabled(true)
        }
    }
    
    private struct FrontCardContent: View {
        @ObservedObject var editCardViewModel: EditCardViewModel
        
        var body: some View {
            ForEach(editCardViewModel.frontCardContent) { (cardContent: CardContentTypeContainer)  in
                CardContent(cardContent: cardContent)
            }
            .onMove(perform: editCardViewModel.moveFrontContent)
            .onDelete(perform: editCardViewModel.deleteFrontContent)
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
        @ObservedObject var editCardViewModel: EditCardViewModel
        
        var body: some View {
            ForEach(editCardViewModel.backCardContent) { (cardContent: CardContentTypeContainer)  in
                CardContent(cardContent: cardContent)
            }
            .onMove(perform: editCardViewModel.moveBackContent)
            .onDelete(perform: editCardViewModel.deleteBackContent)
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
        @ObservedObject var editCardViewModel: EditCardViewModel
        @Binding var presentationMode: PresentationMode
        
        var body: some View {
            Button("Save Card") {
                editCardViewModel.saveCardChanges()
                presentationMode.dismiss()
            }
            .disabled(!editCardViewModel.cardIsSaveable)
        }
    }
}
