//
//  ViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alarm = Alarm()
        alarm.time = Date().addingTimeInterval(20.0)
        addAlarm(alarm: alarm)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAlarm(alarm: Alarm){
        // ask permission for notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (authorized, error) in
            if authorized {
                print("access granted, proceed")
                var date = DateComponents()
                let calendar = Calendar.current
                
                let hour = calendar.component(.hour, from: alarm.time)
                let minutes = calendar.component(.minute, from: alarm.time)
                let seconds = calendar.component(.second, from: alarm.time)
                
                date.hour = hour
                date.minute = minutes
                date.second = seconds
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                
                let content = UNMutableNotificationContent()
                content.categoryIdentifier = "defugue"
                content.title = "Alarm"
                content.body = "wakey wakey"
                content.userInfo = ["customNumber": 100, "time": "hours = \(hour):\(minutes):\(seconds)"]
                content.sound = UNNotificationSound(named: "Elegant.mp3")
                
                let request = UNNotificationRequest(identifier: "exampleNotification", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    
}

