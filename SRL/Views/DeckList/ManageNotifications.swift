//
//  ManageNotifications.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import SwiftUI

struct ManageNotifications: View {
    @ObservedObject var notificationViewModel: NotificationViewModel
    @Binding var isShowingBottomSheet: Bool
    
    var body: some View {
        NavigationView {
            NotificationForm(notificationViewModel: notificationViewModel)
                .navigationBarTitle(Text("Notifications"))
        }
    }
}
