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
            
            self.notifictionCenter.delegate = self
            self.setActionsForNotifications()
        }
    }
    
    func getNotificationAttachment(type: String) -> UNNotificationAttachment? {
        
        guard let url = Bundle.main.url(forResource: type, withExtension: "png") else { return nil }
        
        do {
            
            let attachment = try UNNotificationAttachment(identifier: type, url: url)
            
            return attachment
            
        } catch {
            return nil
        }
        
    }
    
    
    func setActionsForNotifications() {
        
        let timerAction = UNNotificationAction(identifier: "timerAction",
                                               title: "Ok Stop",
                                               options: [.authenticationRequired])
        
        let dateAction = UNNotificationAction(identifier: "dateAction",
                                              title: "Celebrate",
                                              options: [.destructive])
        
        let locationAction = UNNotificationAction(identifier: "locationAction",
                                                  title: "Explore",
                                                  options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: "timerCat",
                                                   actions: [timerAction],
                                                   intentIdentifiers: [])
        
        let dateCategory = UNNotificationCategory(identifier: "dateCat",
                                                   actions: [dateAction],
                                                   intentIdentifiers: [])
        
        let locationCategory = UNNotificationCategory(identifier: "locationCat",
                                                   actions: [locationAction],
                                                   intentIdentifiers: [])
        
        notifictionCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func timerNotification(interval: TimeInterval) {
        
        let content = UNMutableNotificationContent()
        content.title = "Time up!!"
        content.body = "Submit the quiz !!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "timerCat"
        
        if let attachment = getNotificationAttachment(type: "TimeAlert") {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: trigger)
        
        notifictionCenter.add(request)
    }
    
    func dateNotification(dateComponent: DateComponents) {
        
        let content = UNMutableNotificationContent()
        content.title = "Birthday!!"
        content.body = "Yay.. It's your b'day today"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "dateCat"
        
        if let attachment = getNotificationAttachment(type: "DateAlert") {
            content.attachments = [attachment]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: "dateNotification", content: content, trigger: trigger)
        
        notifictionCenter.add(request)
    }
    
    func locationNotification(latitude: Double, longitude: Double) {
        
        let content = UNMutableNotificationContent()
        content.title = "New Location"
        content.body = "You entered a new location with Lat \(latitude) and Long \(longitude)"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "locationCat"
        
        if let attachment = getNotificationAttachment(type: "LocationAlert") {
            content.attachments = [attachment]
        }

        let request = UNNotificationRequest(identifier: "locationNotification", content: content, trigger: nil)

        notifictionCenter.add(request)
    }
}

extension NotificationHelper : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NotificationCenter.default.post(name: NSNotification.Name("actionNotify"), object: response.actionIdentifier)
        
        print("Notification did recieve response called when app is in background or somw other state")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification will present called when app is in open/foreground state")
        
        let notificationOptions : UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(notificationOptions)
    }
}
