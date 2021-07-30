//
//  CardBrowserCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardPreview: View {
    @ObservedObject var deckViewModel: DeckViewModel
    @ObservedObject var presetViewModel: PresetViewModel
    var card: Card
    
    
    var body: some View {
        VStack {
            HStack {
                Text(fetchCardContentPreview())
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }.padding(.bottom, 1)
            HStack {
                Text(card.scheduler.learningState.status)
                Spacer()
                Text(getInterval(card.scheduler))
                Spacer()
                Text(card.scheduler.nextReviewDate.getFormatted(dateFormat: "dd.MM.yyyy"))
            }
        }.padding([.top, .bottom], 5)
    }
    
    private func fetchCardContentPreview() -> String {
        switch (card.content) {
        case .DEFAULT(let defaultCard):
            return defaultCard.preview
        case .TYPING(_): return ""
        }
    }
    
    private func getInterval(_ scheduler: Scheduler) -> String {
        let remainingInterval = scheduler.remainingReviewInterval
        let currentInterval = scheduler.currentReviewInterval
        return remainingInterval.getFormatted() + " / " + currentInterval.getFormatted()
    }
}
