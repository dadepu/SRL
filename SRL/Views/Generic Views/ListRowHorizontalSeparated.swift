//
//  DeckRow.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.06.21.
//

import SwiftUI

struct ListRowHorizontalSeparated: View {
    var textLeft: () -> String
    var textRight: () -> String
    
    var body: some View {
        HStack {
            Text(textLeft())
            Spacer()
            Text(textRight())
                .padding(.horizontal)
        }
    }
}

