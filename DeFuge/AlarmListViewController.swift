//
//  AlarmListViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class AlarmListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CreateAlarmDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alarms: StoredAlarms!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarms = StoredAlarms()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    
        let alarm = Alarm()
        let currentTime = Time.currentTime()
        alarm.time = Time(withHour: currentTime.hour, withMinute: currentTime.minute, withMeridiem: currentTime.meridiem)
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
                date.hour = alarm.time.hour
                date.minute = alarm.time.minute
                
                // TODO remove the next 4 lines
                let currentTime = Date()
                let calendar = Calendar.current
                let second = calendar.component(.second, from: currentTime) + 10
                date.second = second
                //END remove
                
//                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                let categoryId = "com.codepath17.defuge.AlarmNotificationExtension"
                let category = UNNotificationCategory(identifier: categoryId, actions: [], intentIdentifiers: [], options: [])
                center.setNotificationCategories([category])

                let content = UNMutableNotificationContent()
                content.categoryIdentifier = categoryId
                content.title = "Alarm"
                content.body = "wakey wakey"
                content.userInfo = ["customNumber": 100, "time": "hours = \(alarm.time.hour):\(alarm.time.minute)"]
                content.sound = UNNotificationSound(named: "Elegant.mp3")
                
                let request = UNNotificationRequest(identifier: "exampleNotification", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    func saveAlarm(alarm: Alarm) {
        
        alarms.add(alarm: alarm)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        cell.alarm = alarms.getAlarm(withIndex: indexPath.row)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAlarm" {
            let createAlarmViewController = segue.destination as! CreateAlarmViewController
            createAlarmViewController.delegate = self
            
            let alarm = Alarm()
            alarm.time = Time.currentTime()
            createAlarmViewController.alarm = alarm
        }
    }

}

