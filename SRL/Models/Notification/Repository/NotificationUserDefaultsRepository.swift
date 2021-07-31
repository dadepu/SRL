//
//  NotificationUserDefaultsRepository.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation

struct NotificationUserDefaultsRepository {
    private static let userdefaultsDeckKey = "Notification.RootAggregate"
    
    
    func loadNotifications() -> Notifications? {
        let jsonData = UserDefaults.standard.data(forKey: NotificationUserDefaultsRepository.userdefaultsDeckKey)
        if jsonData != nil, let decodedNotifications = try? JSONDecoder().decode(Notifications.self, from: jsonData!) {
            return decodedNotifications
        } else {
            return nil
        }
    }

    func saveNotifications(_ notifications: Notifications) {
        let notificationsJSON = try? JSONEncoder().encode(notifications)
        UserDefaults.standard.set(notificationsJSON, forKey: NotificationUserDefaultsRepository.userdefaultsDeckKey)
    }

    func deleteNotifications() {
        UserDefaults.standard.set("", forKey: NotificationUserDefaultsRepository.userdefaultsDeckKey)
    }
}
