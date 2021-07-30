//
//  CardFrontContent.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct CardFormContentListing: View {
    @ObservedObject var abstractCardViewModel: AbstractCardViewModel
    @Binding var isShowingModal: Bool
    var cardContent: [CardContentTypeContainer]
    var onMoveAction: (IndexSet, Int) -> ()
    var onDeleteAction: (IndexSet) -> ()
    
    
    var body: some View {
        ForEach(cardContent) { (cardContent: CardContentTypeContainer)  in
            CardContent(cardContent: cardContent)
        }
        .onMove(perform: onMoveAction)
        .onDelete(perform: onDeleteAction)
        Button("Add Content") {
            isShowingModal = true
        }
    }
}
