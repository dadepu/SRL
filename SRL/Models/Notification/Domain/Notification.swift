//
//  Notification.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import UserNotifications

struct Notification: Identifiable, Codable {
    private (set) var id = UUID()
    
    private (set) var title = "STUDY Reminder"
    private (set) var subtitle = "You may have pending flashcards, so make sure to check them out!"
    
    private (set) var type: NotificationType
    private (set) var repeats: Bool = true
    private (set) var dateComp: DateComponents
    
    
    init(type: NotificationType) {
        self.type = type
        self.dateComp = Notification.makeDateCompFromType(type: type)
    }
    
    
    var content: UNNotificationContent {
        get {
            let content = UNMutableNotificationContent()
            content.title = self.title
            content.subtitle = self.subtitle
            content.sound = UNNotificationSound.default
            return content
        }
    }
    
    var trigger: UNCalendarNotificationTrigger {
        get {
            UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: repeats)
        }
    }
    
    private static func makeDateCompFromType(type: NotificationType) -> DateComponents {
        var dateComp = DateComponents()
        switch (type) {
        case .AM:
            dateComp.hour = 07;
            dateComp.minute = 00;
        case .PM:
            dateComp.hour = 18;
            dateComp.minute = 00;
        }
        return dateComp
    }
}
