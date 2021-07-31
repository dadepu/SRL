//
//  NotificationLauncherService.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import UserNotifications

struct NotificationLauncherService {
    private var notificationRepository: NotificationRepository
    
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
     
    
    func launchNotification(type: NotificationType, notification: Notification) {
        purgeNotification(type: type)
        requestPermission() { response in }
        let request = UNNotificationRequest(identifier: notification.id.uuidString, content: notification.content, trigger: notification.trigger)
        UNUserNotificationCenter.current().add(request)
        notificationRepository.setNotification(type: type, notification: notification)
    }
    
    func purgeNotification(type: NotificationType) {
        if let notification = notificationRepository.getNotification(type: type) {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.id.uuidString])
        }
        notificationRepository.deleteNotification(type: type)
    }
    
    
    func launchDemoNotification(_ notification: DemoNotification) {
        requestPermission() { response in }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification.content, trigger: notification.trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    private func requestPermission(_ callback: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { response, error in
            callback(response)
        }
    }
}
