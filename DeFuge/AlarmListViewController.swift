//
//  AlarmListViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CreateAlarmDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alarms = [Alarm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Load persisted alarms data
        let sampleAlarm1 = Alarm()
        sampleAlarm1.time.hour! += 2
        
        let sampleAlarm2 = Alarm()
        sampleAlarm1.time.minute! += 5
        
        alarms.append(sampleAlarm1)
        alarms.append(sampleAlarm2)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    
        let alarm = Alarm()
        alarm.time.minute! += 1
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
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)

                let content = UNMutableNotificationContent()
                content.categoryIdentifier = "defugue"
                content.title = "Alarm"
                content.body = "wakey wakey"
                content.userInfo = ["customNumber": 100, "time": "hours = \(alarm.time.hour!):\(alarm.time.minute!)"]
                content.sound = UNNotificationSound(named: "Elegant.mp3")
                
                let request = UNNotificationRequest(identifier: "exampleNotification", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    func saveAlarm(alarm: Alarm) {
        //print(alarm)
        //Persist alarm here
        alarms.append(alarm)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        cell.alarm = alarms[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAlarm" {
            let createAlarmViewController = segue.destination as! CreateAlarmViewController
            createAlarmViewController.delegate = self
            createAlarmViewController.alarm = Alarm()
        }
    }

}

