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
        LocationHelper.shared.validateAuthorizePermission()
        
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
    
}

