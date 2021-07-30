//
//  ReviewFooter.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct ReviewFooter: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    
    @Binding var displayMode: ReviewView.DisplayMode

    var body: some View {
        if displayMode == .revealed {
            LazyVStack {
                HStack {
                    Spacer()
                    Button(action: {
                        reviewViewModel.reviewCard(reviewAction: .REPEAT)
                        displayMode = .question
                    }) {
                        Text("Bad")
                    }.padding()
                    Spacer()
                    Button(action: {
                        reviewViewModel.reviewCard(reviewAction: .HARD)
                        displayMode = .question
                    }) {
                        Text("Hard")
                    }.padding()
                    Spacer()
                    Button(action: {
                        reviewViewModel.reviewCard(reviewAction: .GOOD)
                        displayMode = .question
                    }) {
                        Text("Good")
                    }.padding()
                    Spacer()
                    Button(action: {
                        reviewViewModel.reviewCard(reviewAction: .EASY)
                        displayMode = .question
                    }) {
                        Text("Easy")
                    }.padding()
                    Spacer()
                }
            }
        } else {
            EmptyView()
        }
    }
}
