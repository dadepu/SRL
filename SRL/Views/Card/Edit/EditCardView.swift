//
//  EditCardView.swift
//  SRL
//
//  Created by Daniel Koellgen on 24.07.21.
//

import SwiftUI

struct EditCardView: View {
    @ObservedObject private var storeViewModel: StoreViewModel
    @ObservedObject private var deckViewModel: DeckViewModel
    @ObservedObject private var presetViewModel: PresetViewModel
    @ObservedObject private var editCardViewModel: EditCardViewModel
    
    @State private var isShowingBottomSheetAddContentFront: BottomSheetPosition = .hidden
    @State private var isShowingBottomSheetAddContentBack: BottomSheetPosition = .hidden
    @State private var opacityBottomUpSheets: Double = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var formEaseFactor: Float = 0
    @State private var formPresetIndex: Int = 0
    @State private var formCardType: CardTypeMapper = .Default
    @State private var formDeckIndex: UUID = UUID()
    @State private var isSaveableCard: Bool = false
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    
    init(deckViewModel: DeckViewModel, presetViewModel: PresetViewModel, deck: Deck, card: Card) {
        self.storeViewModel = StoreViewModel()
        self.deckViewModel = deckViewModel
        self.presetViewModel = presetViewModel
        self.editCardViewModel = EditCardViewModel(deck: deck, card: card)
        self._formEaseFactor = State<Float>(initialValue: card.scheduler.easeFactor.easeFactor)
        self._formDeckIndex = State<UUID>(initialValue: deck.id)
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Scheduling")) {
                CurrentLearningState(editCardViewModel: editCardViewModel)
                NumberOfReviews(editCardViewModel: editCardViewModel)
                CurrentInterval(editCardViewModel: editCardViewModel)
                DateDue(editCardViewModel: editCardViewModel)
                EaseFactorPicker(editCardViewModel: editCardViewModel, easeFactor: $formEaseFactor)
                Button(action: {editCardViewModel.graduateScheduler()}, label: {
                    Text("Graduate Scheduler")
                }).disabled(!editCardViewModel.card.scheduler.isGraduateable)
                Button(action: {editCardViewModel.resetCard()}, label: {
                    Text("Reset Scheduler")
                })
            }
            Section(header: Text("Settings")) {
                CardTypePicker(cardType: $formCardType)
                SchedulePresetPicker(presetViewModel: presetViewModel, editCardViewModel: editCardViewModel, presetIndex: $formPresetIndex)
                DeckPicker(storeViewModel: storeViewModel, editCardViewModel: editCardViewModel ,deckIndex: $formDeckIndex)
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
        .modifier(CardFrontContentSheet(createCardViewModel: editCardViewModel, isShowingBottomSheet: $isShowingBottomSheetAddContentFront, opacityBottomSheet: $opacityBottomUpSheets, image: $image, showingImagePicker: $showingImagePicker, inputImage: $inputImage))
        .modifier(CardBackContentSheet(createCardViewModel: editCardViewModel, cardType: $formCardType, isShowingBottomSheet: $isShowingBottomSheetAddContentBack, opacityBottomSheet: $opacityBottomUpSheets, image: $image, showingImagePicker: $showingImagePicker, inputImage: $inputImage))
        .navigationBarTitle("Edit Card", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    
    private struct CurrentLearningState: View {
        @ObservedObject var editCardViewModel: EditCardViewModel
        
        var body: some View {
            ListRowHorizontalSeparated(textLeft: {"Learning State"}, textRight: {translateLearningState(state: editCardViewModel.card.scheduler.learningState)})
        }
    }
    
    private struct NumberOfReviews: View {
        @ObservedObject var editCardViewModel: EditCardViewModel
        
        var body: some View {
            ListRowHorizontalSeparated(textLeft: {"Review Count"}, textRight: {"\(editCardViewModel.card.scheduler.reviewCount)"})
        }
    }
    
    private struct CurrentInterval: View {
        @ObservedObject var editCardViewModel: EditCardViewModel
        
        var body: some View {
            ListRowHorizontalSeparated(textLeft: {"Current Interval"}, textRight: {getFormattedTimeInterval(editCardViewModel.card.scheduler.currentReviewInterval.intervalSeconds)})
        }
    }
    
    private struct DateDue: View {
        @ObservedObject var editCardViewModel: EditCardViewModel
        private var formatter = DateFormatter()
        
        init(editCardViewModel: EditCardViewModel) {
            self.editCardViewModel = editCardViewModel
            formatter = DateFormatter()
            formatter.timeZone = .current
            formatter.locale = .current
            formatter.dateFormat = "dd.MM.yyyy"
        }
        
        var body: some View {
            ListRowHorizontalSeparated(textLeft: {"Next Review"}, textRight: {formatter.string(from: editCardViewModel.card.scheduler.nextReviewDate.date)})
        }
    }
    
    private struct EaseFactorPicker: View {
        @ObservedObject var editCardViewModel: EditCardViewModel
        @Binding var easeFactor: Float
        
        var easeRange: [Float] = [1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0]
        
        var body: some View {
            Picker(selection: $easeFactor, label: Text("Ease Factor")) {
                ForEach(easeRange, id: \.self) { i in
                    Text("\(i, specifier: "%.2f")").tag(i)
                }
            }.onChange(of: easeFactor, perform: { (value: Float) in
                editCardViewModel.setUpdatedEaseFactor(factor: value)
            })
        }
    }
    
    
    private struct SchedulePresetPicker: View {
        @ObservedObject var presetViewModel: PresetViewModel
        @ObservedObject var editCardViewModel: EditCardViewModel
        @Binding var presetIndex: Int
        
        var body: some View {
            Picker(selection: $presetIndex, label: Text("Scheduler Preset")) {
                ForEach(0 ..< presetViewModel.orderedPresets.count) {
                    Text(self.presetViewModel.orderedPresets[$0].name)
                }
            }.onChange(of: presetIndex, perform: { (value: Int) in
//                if let _ = presetViewModel.getPreset(forIndex: value) {
//                    
//                }
            })
        }
    }
    
    private struct DeckPicker: View {
        @ObservedObject var storeViewModel: StoreViewModel
        @ObservedObject var editCardViewModel: EditCardViewModel
        @Binding var deckIndex: UUID
        
        var body: some View {
            Picker(selection: $deckIndex, label: Text("Deck")) {
                ForEach(storeViewModel.orderedDecks) { deck in
                    Text(deck.name)
                }
            }.onChange(of: deckIndex, perform: { deckId in
                editCardViewModel.setTransferDeckId(destinationId: deckId)
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
    
    static func getFormattedTimeInterval(_ time: TimeInterval) -> String {
        if abs(time) < 60 {
            let seconds = Int(time)
            return "\(seconds) Sec(s)"
        }
        if abs(time) < (60 * 60) {
            let minutes = Int((time / 60).rounded(.up))
            return "\(minutes) Min(s)"
            
        }
        if abs(time) < (60 * 60 * 24) {
            let hours = Int((time / (60 * 60)).rounded(.up))
            return "\(hours) Hour(s)"
        }
        let days = Int((time / (60 * 60 * 24)).rounded(.up))
        return "\(days) Day(s)"
    }
    
    static func translateLearningState(state: LearningState) -> String {
        switch (state) {
        case .LEARNING: return "Learning"
        case .REVIEW: return "Reviewing"
        case .LAPSE: return "Lapsing"
        }
    }
}
