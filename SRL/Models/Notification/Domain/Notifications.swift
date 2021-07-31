//
//  Notifications.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation

struct Notifications: Codable {
    var AM: Notification?
    var PM: Notification?
    
    
    mutating func setNotification(type: NotificationType, value: Notification?) {
        switch (type) {
        case .AM:
            AM = value
        case .PM:
            PM = value
        }
    }
    
    func hasSetNotification(type: NotificationType, value: Notification?) -> Notifications {
        var updatedNotifications = self
        updatedNotifications.setNotification(type: type, value: value)
        return updatedNotifications
    }
    
    func getNotification(type: NotificationType) -> Notification? {
        switch (type) {
        case .AM:
            return AM
        case .PM:
            return PM
        }
    }
}
