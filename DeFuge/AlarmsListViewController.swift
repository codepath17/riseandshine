//
//  ViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        let alarm = Alarm()
        alarm.time = Date().addingTimeInterval(20.0)
        addAlarm(alarm: alarm)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = Date();
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmListCell") as! AlarmListCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " HH:mm" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date)
        print(newDate) //New formatted Date string
        let fireDate = date.addingTimeInterval(60.0)
        let newFireDate = dateFormatter.string(from: fireDate)
        print(newFireDate) //New formatted Date string
        
//        setupNotification(date)
        cell.alarmLabel.text = newDate
        cell.alarmDesc.text = "Alarm"
        cell.alarmSwitch.isOn = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func setupNotification(_ date: Date) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        AlarmNotification.fireDate = date
        AlarmNotification.soundName = "trial.mp3"
        AlarmNotification.timeZone = TimeZone.current
        UIApplication.shared.scheduleLocalNotification(AlarmNotification)
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

