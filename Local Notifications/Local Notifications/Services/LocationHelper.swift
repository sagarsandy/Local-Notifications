//
//  LocationHelper.swift
//  Local Notifications
//
//  Created by Sagar Sandy on 09/10/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject {
    
    private override init() {
        
    }
    
    static let shared = LocationHelper()
    
    let locationManager = CLLocationManager()
    
    func validateAuthorizePermission(){
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Got location")
        
        NotificationCenter.default.post(name: Notification.Name("enteredLocation"), object: locations)
        
        print(locations.first!.timestamp)
        print(locations.first!.coordinate.latitude)
        print(locations.first!.coordinate.longitude)
        
        NotificationHelper.shared.locationNotification(latitude:locations.first!.coordinate.latitude , longitude: locations.first!.coordinate.longitude)
        
//        guard let currentLocation = locations.first else { return }
//
//        let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "locationRegion")
//        manager.startMonitoring(for: region)
    }
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//
//        print("Did enter region")
//
//        print(region)
//
//        NotificationCenter.default.post(name: Notification.Name("enteredRegion"), object: nil)
//
//    }
    
}
