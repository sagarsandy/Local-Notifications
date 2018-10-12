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
    
    // Initializing location manager
    lazy var locationManager = CLLocationManager()
    
    //Location manager settings for asking current location of user
    func validateAuthorizePermission(){
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        
        // To run location updateds in app background state we need to mention below line and "Required background modes" in info.plist file
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    // Location manager update location method
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: Location manager delegete methods
extension LocationHelper: CLLocationManagerDelegate {
    
    // Once the user location is changed, this method wil be fired automatically
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Got location")
        print(locations.first!.timestamp)
        print(locations.first!.coordinate.latitude)
        print(locations.first!.coordinate.longitude)
        
        // Calling notification manager method to display location related notification
        NotificationHelper.shared.locationNotification(latitude:locations.first!.coordinate.latitude , longitude: locations.first!.coordinate.longitude)
    }
    
}
