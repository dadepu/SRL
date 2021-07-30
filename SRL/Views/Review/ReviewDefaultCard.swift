//
//  ReviewDefaultCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct ReviewDefaultCard: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    
    @Binding var displayMode: ReviewView.DisplayMode
    
    var card: Card
    var content: DefaultCard
    
    
    var body: some View {
        List {
            Section(header: Text("Question")) {
                ForEach(content.questionContent) { container in
                    CardContent(cardContent: container)
                }
            }
            if (displayMode == .revealed) {
                Section(header: Text("Answer")) {
                    ForEach(content.answerContent) { container in
                        CardContent(cardContent: container)
                    }
                }
            }
            
        }
        .listStyle(GroupedListStyle())
        .onTapGesture(perform: {displayMode = .revealed})
        ReviewFooter(reviewViewModel: reviewViewModel, displayMode: $displayMode)
    }
}
