//
//  NotificationService.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import UserNotifications

struct NotificationService {
    private let notificationRepository = NotificationRepository.getInstance()

    func getModelPublisher() -> Published<Notifications>.Publisher {
        notificationRepository.$notifications
    }
    
    
    func getNotifications() -> Notifications {
        notificationRepository.notifications
    }
    
    func scheduleDemoNotification() {
        NotificationLauncherService(notificationRepository: notificationRepository).launchDemoNotification(DemoNotification())
    }
    
    func updateNotificationActivation(type: NotificationType, status: Bool) {
        let notificationLauncherService = NotificationLauncherService(notificationRepository: notificationRepository)
        if status {
            let notification = Notification(type: type)
            notificationLauncherService.launchNotification(type: type, notification: notification)
        } else {
            notificationLauncherService.purgeNotification(type: type)
        }
    }
}
