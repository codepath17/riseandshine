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
let MAX_STEP_COUNT = 50

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var progressBarView: ProgressBarView!

    var stepCount : NSNumber!
    private let pedometer = CMPedometer()
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarView.max = MAX_STEP_COUNT

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
                            let progress = Int(stepCount)

                            self.progressBarView.progress = Int(progress)
                            self.stepCount = stepCount
                        }
                    }
                })
            })
        }
    }

}
