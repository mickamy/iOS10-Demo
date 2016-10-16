//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Tetsuro Mikami on 10/16/16.
//  Copyright © 2016 Tetsuro Mikami. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class NotificationViewController
    : UIViewController
    , UNNotificationContentExtension {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        guard
            let lat = content.userInfo["latitude"] as? Double,
            let lon = content.userInfo["longitude"] as? Double
        else {
            print("Could not get lat/lon.")
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        mapView.region = region
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotations([annotation])
    }
}
