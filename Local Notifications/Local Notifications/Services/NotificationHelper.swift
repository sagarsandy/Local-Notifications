//
//  NotificationHelper.swift
//  Local Notifications
//
//  Created by Sagar Sandy on 06/10/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHelper : NSObject {
    
    private override init() {}
    static let shared = NotificationHelper()
    let notifictionCenter = UNUserNotificationCenter.current()
    
    func validateAuthorizePermission(){
        let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
        
        notifictionCenter.requestAuthorization(options: authOptions) { (isGranted, error) in
            print(error ?? "Permission granted for notifications")
            
            guard isGranted else {
                print("User permission denied")
                return
            }
        }
    }
}

extension NotificationHelper : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Notification did recieve response called when app is in background or somw other state")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification will present called when app is in open/foreground state")
        
        let notificationOptions : UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(notificationOptions)
    }
}
