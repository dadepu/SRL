//
//  CardBackContentSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardBackContentSheet: ViewModifier {
    @ObservedObject var createCardViewModel: AbstractCardViewModel
    
    @Binding var cardType: CardTypeMapper
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var opacityBottomSheet: Double
    
    @Binding var image: Image?
    @Binding var showingImagePicker: Bool
    @Binding var inputImage: UIImage?
    
    
    func body(content: Content) -> some View {
        content.modifier(CardContentSheet(createCardViewModel: createCardViewModel, isShowingSheet: $isShowingBottomSheet, opacitySheet: $opacityBottomSheet, allowedContentTypes: getAvailableTypes(), image: $image, showingImagePicker: $showingImagePicker, inputImage: $inputImage, saveAction: appendContentToBack))
    }
    
    
    private func getAvailableTypes() -> [ContentTypeMapper] {
        switch (cardType) {
            case .Default: return [.Text, .Image]
        }
    }
    
    private func appendContentToBack(content: CardContentType, cardViewModel: AbstractCardViewModel) {
        cardViewModel.addBackContent(content)
    }
}