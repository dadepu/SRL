//
//  ReviewCustomIntervalSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.07.21.
//

import SwiftUI

struct ReviewCustomIntervalSheet: ViewModifier {
    @ObservedObject var reviewViewModel: ReviewViewModel
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var opacityBottomSheet: Double
    
    @State var formHours: Int = 0
    @State var formMinutes: Int = 0
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.swipeToDismiss, .tapToDissmiss, .noBottomPosition, .notResizeable, .noDragIndicator], headerContent: sheetHeader, mainContent: sheetContent, opacity: $opacityBottomSheet)
    }
    
    private func sheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Set Interval")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func sheetContent() -> some View {
        VStack {
            GeometryReader { geometry in
                HStack {
                    Picker("", selection: $formHours){
                        ForEach(0..<365, id: \.self) { i in
                            Text("\(i) days").tag(i)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(3), height: geometry.size.height)
                    .clipped()
                    Picker("", selection: $formHours){
                        ForEach(0..<24, id: \.self) { i in
                            Text("\(i) hours").tag(i)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(3), height: geometry.size.height)
                    .clipped()
                    Picker("", selection: $formMinutes){
                        ForEach(0..<60, id: \.self) { i in
                            Text("\(i) min").tag(i)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(3), height: geometry.size.height)
                    .clipped()
                }
            }
//            List {
                Button(action: {isShowingBottomSheet = .hidden}, label: {
                    HStack {
                        Spacer()
                        Text("Save")
                            .bold()
                        Spacer()
                    }
                })
//            }
//            .listStyle(InsetGroupedListStyle())
        }
    }
}
