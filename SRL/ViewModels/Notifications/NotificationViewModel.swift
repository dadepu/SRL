//
//  NotificationViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation

class NotificationViewModel: ObservableObject {
    
    func scheduleDemoNotification() {
        NotificationService().scheduleDemoNotification()
    }
}
