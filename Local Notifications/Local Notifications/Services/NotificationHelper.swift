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
    
    // Initializing local notification related object
    let notifictionCenter = UNUserNotificationCenter.current()
    
    // Asking user permission to send local notifications
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
    
    // Fetching attachment from project library to display in the notiifactions
    func getNotificationAttachment(type: String) -> UNNotificationAttachment? {
        
        guard let url = Bundle.main.url(forResource: type, withExtension: "png") else { return nil }
        
        do {
            
            let attachment = try UNNotificationAttachment(identifier: type, url: url)
            
            return attachment
            
        } catch {
            return nil
        }
        
    }
    
    // Definign actions and categories in the local notifications
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
    
    // Timer notification related mothod
    func timerNotification(interval: TimeInterval) {
        
        var notificationData = Dictionary<String, String>()
        notificationData["title"] = "Time up!!"
        notificationData["body"] = "Submit the quiz !!"
        notificationData["identifier"] = "timerCat"
        notificationData["notificationType"] = "TimeAlert"
        
        let notificationContent = prepareNotificationContent(notificationData: notificationData)
        // Trigger will be fired whenever the time interval meet
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "timerNotification", content: notificationContent, trigger: trigger)
        
        notifictionCenter.add(request)
    }
    
    // Date notification related mothod
    func dateNotification(dateComponent: DateComponents) {
        
        
        var notificationData = Dictionary<String, String>()
        notificationData["title"] = "Birthday !!"
        notificationData["body"] = "Yay.. It's your b'day today"
        notificationData["identifier"] = "dateCat"
        notificationData["notificationType"] = "DateAlert"
        
        let notificationContent = prepareNotificationContent(notificationData: notificationData)
        // Trigger will be fired whenever the date component meet
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: "dateNotification", content: notificationContent, trigger: trigger)
        
        notifictionCenter.add(request)
    }
    
    // Location notification related mothod
    func locationNotification(latitude: Double, longitude: Double) {
        
        var notificationData = Dictionary<String, String>()
        notificationData["title"] = "New Location"
        notificationData["body"] = "You entered a new location with Lat \(latitude) and Long \(longitude)"
        notificationData["identifier"] = "locationCat"
        notificationData["notificationType"] = "LocationAlert"
        
        let notificationContent = prepareNotificationContent(notificationData: notificationData)
        // There will be no trigger in this, whenever user entered a new location this notification will called from location manager delegate method directly.
        let request = UNNotificationRequest(identifier: "locationNotification", content: notificationContent, trigger: nil)

        notifictionCenter.add(request)
    }
    
    // Function to prepare notifcation content
    func prepareNotificationContent(notificationData: Dictionary<String, String>) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        content.title = notificationData["title"]!
        content.body = notificationData["body"]!
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = notificationData["identifier"]!
        
        if let attachment = getNotificationAttachment(type: notificationData["notificationType"]!) {
            content.attachments = [attachment]
        }
        
        return content
    }
}

// MARK: Location notification delegate methods
extension NotificationHelper : UNUserNotificationCenterDelegate {
    
    // Whenever the notification receives, then this method will be called
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Added observer relaed notification, so that when ever user presses button in notification, then this will notify the associated observer.
        NotificationCenter.default.post(name: NSNotification.Name("actionNotify"), object: response.actionIdentifier)
        
        print("Notification did recieve response called when app is in background or somw other state")
        
        completionHandler()
    }
    
    // When the notification is recieved in the foreground/app runnign state then this method will be called.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification will present called when app is in open/foreground state")
        
        // If the application is in foreground state, we have to mention again about notification properties.
        let notificationOptions : UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(notificationOptions)
    }
}
