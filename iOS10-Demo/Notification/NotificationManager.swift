//
//  NotificationManager.swift
//  iOS10-Demo
//
//  Created by Tetsuro Mikami on 10/15/16.
//  Copyright © 2016 Tetsuro Mikami. All rights reserved.
//

import Foundation
import UserNotifications

final class NotificationManager: NSObject {
    
    static let instance = NotificationManager()
    
    private let remoteImageURL = URL(
        string: "http://free-photos-ls01.gatag.net/images/lgf01a201306271900.jpg")!
    
    private override init() {
        super.init()
        center.delegate = self
        setActionCategory()
    }
    
    private func setActionCategory() {
        let action = UNNotificationAction(
            identifier: "sample-action",
            title: "Sample Action"
        )
        let category = UNNotificationCategory(
            identifier: "action",
            actions: [action],
            intentIdentifiers: []
        )
        center.setNotificationCategories([category])
    }
    
    func notify(after sec: TimeInterval) {
        let content = defaultContent
        request(content) { error in
            print("Request notification finished: \(error)")
        }
    }
    
    func notify(with fileURL: URL, identifier: String) {
        let content = defaultContent
        do {
            let attachment = try UNNotificationAttachment(
                identifier: identifier,
                url: fileURL,
                options: nil
            )
            content.attachments = [attachment]
        } catch(let error) {
            print("Could not instantiate attachment: \(error)")
        }
        request(content) { error in
            print("Request notification finished: \(error)")
        }
    }
    
    func notifyWithCustomUI() {
        let content = defaultContent
        content.categoryIdentifier = NotificationCategory.customUI.rawValue
        content.userInfo = [
            "latitude": 35.666699,
            "longitude": 139.708586
        ]
        request(content) { error in
            print("Request notification finished: \(error)")
        }
    }
    
    func notifyWithAction() {
        let content = defaultContent
        content.categoryIdentifier = NotificationCategory.action.rawValue
        request(content) { error in
            print("Request notification finished: \(error)")
        }
    }
}

fileprivate extension NotificationManager {
    
    var center: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    var defaultContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        return content
    }
    
    func trigger(after sec: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: sec, repeats: false
        )
    }
    
    func request(_ content: UNNotificationContent,
                 completionHandler: ((Error?) -> Swift.Void)? = nil) {
        let request = UNNotificationRequest(
            identifier: "\(content.categoryIdentifier)-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: self.trigger(after: 5)
        )
        center.add(request, withCompletionHandler: completionHandler)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler handler: @escaping
                                (UNNotificationPresentationOptions) -> Void) {
        handler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler handler: @escaping () -> Void) {
        let content = response.notification.request.content
        if content.categoryIdentifier == NotificationCategory.action.rawValue {
            print("Action selected: \(response.actionIdentifier)")
            /// Do something for selected action!
        }
        handler()
    }
}

extension NotificationManager {
    
    class func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Error on request authorization: \(error)")
                }
                print("Request authorization finished: granted=\(granted)")
        }
    }
}

enum NotificationCategory: String {
    
    case customUI
    case action    
}
