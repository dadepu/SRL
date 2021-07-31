//
//  NotificationForm.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import SwiftUI

struct NotificationForm: View {
    @ObservedObject var notificationViewModel: NotificationViewModel
    @State var morningNotification: Bool = false
    @State var eveningNotification: Bool = false
    
    @State var demoNotification: Bool = false
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $morningNotification, label: {
                    Text("07:00 Reminder")
                })
                Toggle(isOn: $eveningNotification, label: {
                    Text("18:00 Reminder")
                })
            }
            Section {
                Toggle(isOn: $demoNotification, label: {
                    Text("Demo Notification")
                        .onChange(of: demoNotification, perform: { (toggle: Bool )in
                            guard toggle else { return }
                            notificationViewModel.scheduleDemoNotification()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                demoNotification = false
                            }
                        })
                })
            }
        }.listStyle(GroupedListStyle())
    }
}
