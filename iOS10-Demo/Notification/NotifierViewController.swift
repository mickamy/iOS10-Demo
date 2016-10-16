//
//  NotifierViewController.swift
//  iOS10-Demo
//
//  Created by Tetsuro Mikami on 10/16/16.
//  Copyright © 2016 Tetsuro Mikami. All rights reserved.
//

import UIKit

final class NotifierViewController: UIViewController {
    
    let manager = NotificationManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification"
    }
    
    @IBAction func notifyAfterFiveSec(_ sender: AnyObject) {
        manager.notify(after: 5)
    }
    
    @IBAction func notifyWithImage(_ sender: AnyObject) {
        guard let imageURL = R.file.sampleJpg() else {
            print("Could not instantiate file URL!")
            return
        }
        manager.notify(with: imageURL, identifier: "jpg")
    }
    
    @IBAction func notifyWithSound(_ sender: AnyObject) {
        guard let imageURL = R.file.sampleMp3() else {
            print("Could not instantiate file URL!")
            return
        }
        manager.notify(with: imageURL, identifier: "mp3")
    }
    
    @IBAction func notifyWithMovie(_ sender: AnyObject) {
        guard let imageURL = R.file.sampleMp4() else {
            print("Could not instantiate file URL!")
            return
        }
        manager.notify(with: imageURL, identifier: "mp4")
    }
    
    @IBAction func notifyWithCustomUI(_ sender: AnyObject) {
        manager.notifyWithCustomUI()
    }
    
    @IBAction func notifyWithAction(_ sender: AnyObject) {
        manager.notifyWithAction()
    }
}
