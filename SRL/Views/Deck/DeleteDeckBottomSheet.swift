//
//  DeleteDeckSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct DeleteDeckBottomSheet: ViewModifier {
    @Binding var presentationMode: PresentationMode
    @Binding var isShowingBottomSheet: BottomSheetPosition
    
    var deckViewModel: DeckViewModel
    
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.allowContentDrag, .swipeToDismiss, .tapToDissmiss, .noBottomPosition, .notResizeable], headerContent: sheetHeader, mainContent: sheetContent)
    }
    
    private func sheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Delete Deck")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func sheetContent() -> some View {
        VStack(spacing: 0) {
            List {
                Text("Are you sure?")
                    .foregroundColor(.red)
                    .bold()
                Text("Your deck will be removed permanently. Once your deck is removed, it can not be restored. Associated cards will be removed as well.")
                    .foregroundColor(.red)
            }
            .listStyle(InsetGroupedListStyle())
            Button(action: {
                deleteDeckAction()
                presentationMode.dismiss()
            }, label: {
                Text("Remove Deck")
                    .bold()
                    .foregroundColor(.red)
            })
            Spacer()
        }
    }
    
    private func deleteDeckAction() {
        deckViewModel.dropDeck(id: deckViewModel.deck.id)
    }
}
