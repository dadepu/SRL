//
//  CardBrowserCard.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardBrowserCard: View {
    var card: Card
    
    
    var body: some View {
        VStack {
            HStack {
                Text(fetchCardContentPreview(card))
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }.padding(.bottom, 1)
            HStack {
                Text(getCardLearningState(card.scheduler))
                Spacer()
                Text(getInterval(card.scheduler))
                Spacer()
                Text(getCardDateDue(card.scheduler))
            }
        }.padding([.top, .bottom], 5)
    }
    
    private func fetchCardContentPreview(_ card: Card) -> String {
        switch (card.content) {
        case .DEFAULT(let defaultCard):
            return getDefaultCardContentPreview(defaultCard)
        case .TYPING(_): return ""
        }
    }
    
    private func getDefaultCardContentPreview(_ card: DefaultCard) -> String {
        switch (card.questionContent[0].content) {
        case .TEXT(let textContent): return textContent.text
        case .IMAGE(_): return "<Image>"
        case .TYPING(_): return ""
        }
    }
    
    private func getCardLearningState(_ scheduler: Scheduler) -> String {
        switch(scheduler.learningState) {
        case .LEARNING: return "Learning"
        case .REVIEW: return "Review"
        case .LAPSE: return "Lapse"
        }
    }
    
    private func getInterval(_ scheduler: Scheduler) -> String {
        let currentInterval = scheduler.currentReviewInterval
        let remainingInterval = scheduler.remainingReviewInterval
        
        return "\(getFormattedTimeInterval(remainingInterval)) / \(getFormattedTimeInterval(currentInterval))"
    }
    
    private func getCardDateDue(_ scheduler: Scheduler) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: scheduler.nextReviewDate)
    }
     
    private func getFormattedTimeInterval(_ time: TimeInterval) -> String {
        if abs(time) < 60 {
            let seconds = Int(time)
            return "\(seconds)s"
        }
        if abs(time) < (60 * 60) {
            let minutes = Int((time / 60).rounded(.up))
            return "\(minutes)m"
            
        }
        if abs(time) < (60 * 60 * 24) {
            let hours = Int((time / (60 * 60)).rounded(.up))
            return "\(hours)h"
        }
        let days = Int((time / (60 * 60 * 24)).rounded(.up))
        return "\(days)d"
    }
}
