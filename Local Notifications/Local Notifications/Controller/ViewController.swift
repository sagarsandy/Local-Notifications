//
//  ViewController.swift
//  Local Notifications
//
//  Created by Sagar Sandy on 06/10/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Asking user to give permission for local notifications
        NotificationHelper.shared.validateAuthorizePermission()
        
        // Asking user to give permission for location usage
        LocationHelper.shared.validateAuthorizePermission()
        
        // Added observer for notification action, whenever the user presses button in noitification, then this observer will fire the associated selector method
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationActions(_:)), name: NSNotification.Name("actionNotify"), object: nil)
        
    }
    
    
    
    // MARK: IBActions
    @IBAction func timerNotificationButtonPressed(_ sender: UIButton) {
        
        NotificationHelper.shared.timerNotification(interval: 5)
        
    }
    
    @IBAction func DateNotificationButtonPressed(_ sender: UIButton) {
        
        var components = DateComponents()
        components.second = 0
        
        NotificationHelper.shared.dateNotification(dateComponent: components)
        
    }
    
    @IBAction func locationNotificationButtonPressed(_ sender: UIButton) {
        
        LocationHelper.shared.updateLocation()
    }
    
    
    // Whenever the notification action handled observer(mentioned in view didload) has some action, this method will be executed
    @objc func handleNotificationActions(_ sender : Notification) {
        
        guard let actionName = sender.object as? String else { return }

        switch actionName {
            case "timerAction": runTimerActionRelatedCodeBlock()
                break
            
            case "dateAction": runDateActionRelatedCodeBlock()
                break
            
            case "locationAction": runLocationActionRelatedCodeBlock()
                break
            
            default: print("some thing went wrong")
        }
    }
    
    // These methods will be executed depends on the notification type
    func runTimerActionRelatedCodeBlock() {
        print("Timer logic executed")
    }
    
    func runDateActionRelatedCodeBlock() {
        print("Date logic executed")
    }
    
    func runLocationActionRelatedCodeBlock() {
        print("Location logic executed")
    }
    
}

