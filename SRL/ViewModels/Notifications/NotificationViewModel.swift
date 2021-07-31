//
//  NotificationViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    @Published private (set) var notifications: Notifications
    
    private var notificationObserver: AnyCancellable?
    
    
    init() {
        self.notifications = NotificationService().getNotifications()
        
        self.notificationObserver = NotificationService().getModelPublisher().sink { notifications in
            self.notifications = notifications
        }
    }
    
    func scheduleDemoNotification() {
        NotificationService().scheduleDemoNotification()
    }
    
    func updateNotificationStatus(type: NotificationType, status: Bool) {
        NotificationService().updateNotificationActivation(type: type, status: status)
    }
}
