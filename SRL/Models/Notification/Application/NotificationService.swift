//
//  NotificationService.swift
//  SRL
//
//  Created by Daniel Koellgen on 31.07.21.
//

import Foundation
import UserNotifications

struct NotificationService {

    func scheduleDemoNotification() {
        let demo = DemoNotification()
        requestPermission() { response in }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: demo.content, trigger: demo.trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    private func requestPermission(_ callback: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { response, error in
            callback(response)
        }
    }
}
