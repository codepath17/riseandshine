//
//  NotificationViewController.swift
//  AlarmNotificationExtension
//
//  Created by Nishanko, Nishant on 5/1/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreMotion

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    var stepCount : NSNumber!
    private let pedometer = CMPedometer()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func didReceive(_ notification: UNNotification) {
        countSteps()
    }
    
    func countSteps(){
        if(CMPedometer.isStepCountingAvailable()) {
            pedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                DispatchQueue.main.sync(execute: {
                    if(error == nil){
                        if let stepCount = data?.numberOfSteps {
                            self.stepCount = stepCount
                            self.label?.text = "\(stepCount)"
                        }else{
                            self.label?.text = "no data"
                        }
                    }
                })
            })
        }
    }

}
