//
//  NotificationService.swift
//  NotificationService
//
//  Created by Tetsuro Mikami on 10/16/16.
//  Copyright © 2016 Tetsuro Mikami. All rights reserved.
//

import UserNotifications
import AlamofireImage

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private var libraryDir: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler:
                             @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            guard
                let urlString = bestAttemptContent.userInfo["remote-url"] as? String,
                let remoteURL = URL(string: urlString)
            else {
                contentHandler(bestAttemptContent)
                return
            }
            let destination = URL(fileURLWithPath: "\(libraryDir)/\(remoteURL.lastPathComponent)")
            
            download(remoteURL, to: destination) { url, error in
                guard let fileURL = url else {
                    print(error)
                    contentHandler(bestAttemptContent)
                    return
                }
                do {
                    let attachment = try UNNotificationAttachment(
                        identifier: "remote", url: fileURL
                    )
                    bestAttemptContent.attachments = [attachment]
                    contentHandler(bestAttemptContent)
                } catch(let e) {
                    print(e)
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
    
    private func download(_ remoteURL: URL,
                          to destination: URL,
                          completionHandler handler:
                          @escaping (URL?, Error?) -> Void) {
        ImageDownloader.default.download(URLRequest(url: remoteURL)) { dataResponse in
            guard let data = dataResponse.data else {
                let error = NSError(domain: "Could not get remote data: \(dataResponse.result.error)", code: 0)
                handler(nil, error)
                return
            }
            do {
                try data.write(to: destination)
                handler(destination, nil)
            } catch(let error) {
                handler(nil, error)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            bestAttemptContent.title = "\(bestAttemptContent.title) [Time Expired]"
            contentHandler(bestAttemptContent)
        }
    }

}
