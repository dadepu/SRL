//
//  DemoNotification.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import UserNotifications

struct DemoNotification {
    private let title = "STUDY Reminder"
    private let subtitle = "You may have pending flashcards, so make sure to check them out!"
    private let sound = UNNotificationSound.default
    
    private let interval = 5.0
    private let repeatInterval = false
    
    var content: UNNotificationContent {
        get {
            let content = UNMutableNotificationContent()
            content.title = self.title
            content.subtitle = self.subtitle
            content.sound = self.sound
            return content
        }
    }
    
    var trigger: UNTimeIntervalNotificationTrigger {
        get {
            UNTimeIntervalNotificationTrigger(timeInterval: self.interval, repeats: self.repeatInterval)
        }
    }
    
}
