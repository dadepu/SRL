//
//  ReviewTypingCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct ReviewTypingCard: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    
    @Binding var displayMode: ReviewView.DisplayMode
    
    var card: Card
    var content: TypingCard
    
    
    var body: some View {
        EmptyView()
            .onAppear(perform: {reviewViewModel.reviewCard(reviewAction: .REPEAT)})
    }
}
