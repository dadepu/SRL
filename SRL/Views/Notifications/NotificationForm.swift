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
    
    init(notificationViewModel: NotificationViewModel) {
        self.notificationViewModel = notificationViewModel
        if notificationViewModel.notifications.AM != nil {
            self._morningNotification = State<Bool>(wrappedValue: true)
        }
        if notificationViewModel.notifications.PM != nil {
            self._eveningNotification = State<Bool>(wrappedValue: true)
        }
    }
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $morningNotification, label: {
                    Text("07:00 Reminder")
                })
                .onChange(of: morningNotification, perform: { status in
                    notificationViewModel.updateNotificationStatus(type: .AM, status: status)
                })
                Toggle(isOn: $eveningNotification, label: {
                    Text("18:00 Reminder")
                })
                .onChange(of: eveningNotification, perform: { status in
                    notificationViewModel.updateNotificationStatus(type: .PM, status: status)
                })
            }
            Section {
                Toggle(isOn: $demoNotification, label: {
                    Text("Demo Notification")
                })
                .onChange(of: demoNotification, perform: { (toggle: Bool )in
                    guard toggle else { return }
                    notificationViewModel.scheduleDemoNotification()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        demoNotification = false
                    }
                })
            }
        }.listStyle(GroupedListStyle())
    }
}
