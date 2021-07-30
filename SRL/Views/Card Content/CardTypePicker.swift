//
//  CardTypePicker.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import SwiftUI

struct CardTypePicker: View {
    @ObservedObject var createCardViewModel: CreateCardViewModel
    @Binding var cardType: CardTypeMapper
    
    var body: some View {
        Picker(selection: $cardType, label: Text("Card Type")) {
            ForEach(CardTypeMapper.allCases) { cardType in
                Text(cardType.rawValue)
                    .tag(cardType)
            }
        }.onChange(of: cardType, perform: { (type: CardTypeMapper) in
            createCardViewModel.changeCardType(cardType: type)
        })
    }
}
