//
//  AddPresetSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 04.07.21.
//

import SwiftUI

struct AddPresetSheet: ViewModifier {
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var opacityBottomSheet: Double
    
    @State private var formPresetName: String = ""
    @State private var formLearningSteps: String = ""
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $isShowingBottomSheet, options: [.swipeToDismiss, .tapToDissmiss, .noBottomPosition], headerContent: sheetHeader, mainContent: sheetContent, opacity: $opacityBottomSheet)
    }
    
    private func sheetHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Add New Preset")
                .font(.title).bold()
            Divider()
        }
    }
    
    private func sheetContent() -> some View {
        VStack {
            List {
                Section(header: Text("Preset")){
                    TextField("Deck Name", text: $formPresetName)
                    
                }
                Section(header: Text("Learning Phase")) {
                    TextField("Learning Steps", text: $formLearningSteps)
                    TextField("Graduation Interval", text: $formLearningSteps)
                }
                Section(header: Text("Lapses")) {
                    TextField("Lapse Steps", text: $formLearningSteps)
                    TextField("Minimum Interval", text: $formLearningSteps)
                }
                Section(header: Text("Factor Modifier")) {
                    TextField("Ease Factor", text: $formLearningSteps)
                    TextField("Easy Modifier", text: $formLearningSteps)
                    TextField("Normal Modifier", text: $formLearningSteps)
                    TextField("Hard Modifier", text: $formLearningSteps)
                }
                Section(header: Text("Interval Modifier")) {
                    TextField("Lapse Modifier", text: $formLearningSteps)
                    TextField("Easy Modifier", text: $formLearningSteps)
                }
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("Add Preset")
                            .bold()
                    }
                })
            }
            .listStyle(GroupedListStyle())
            
        }
    }
}
