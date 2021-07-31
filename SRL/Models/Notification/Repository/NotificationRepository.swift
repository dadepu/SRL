//
//  NotificationRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import Combine

class NotificationRepository {
    private static var instance: NotificationRepository?
    private (set) var userDefaultsRepository = NotificationUserDefaultsRepository()
    
    @Published private (set) var notifications: Notifications
    
    private var dataSaving: AnyCancellable?
    
    
    static func getInstance() -> NotificationRepository {
        if NotificationRepository.instance == nil {
            NotificationRepository.instance = NotificationRepository()
        }
        return NotificationRepository.instance!
    }
    
    private init() {
        self.notifications = Notifications()
        if let loadedNotifications: Notifications = userDefaultsRepository.loadNotifications() {
            self.notifications = loadedNotifications
        }
        dataSaving = $notifications.sink { notifications in
            self.userDefaultsRepository.saveNotifications(notifications)
        }
    }
    
    func setNotification(type: NotificationType, notification: Notification) {
        notifications = notifications.hasSetNotification(type: type, value: notification)
    }
    
    func getNotification(type: NotificationType) -> Notification? {
        notifications.getNotification(type: type)
    }
    
    func deleteNotification(type: NotificationType) {
        notifications = notifications.hasSetNotification(type: type, value: nil)
    }
    
    func deleteAllNotifications() {
        notifications = Notifications()
    }
}
