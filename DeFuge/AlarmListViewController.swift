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

class AlarmListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, EditAlarmDelegate {
    
    var alarms: StoredAlarms!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onAddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AlarmSegue", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarms = StoredAlarms()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func weekdays() -> [String: Int] {
        return [
            DayOfWeek.Sunday.rawValue: 1,
            DayOfWeek.Monday.rawValue: 2,
            DayOfWeek.Tuesday.rawValue: 3,
            DayOfWeek.Wednesday.rawValue: 4,
            DayOfWeek.Thursday.rawValue: 5,
            DayOfWeek.Friday.rawValue: 6,
            DayOfWeek.Saturday.rawValue: 7,
        ]
    }
    
    func setAlarmNotification(alarm: Alarm){
        // ask permission for notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (authorized, error) in
            if authorized {
                print("access granted, proceed")
                
                for day in alarm.recurrance {
                    var date = DateComponents()
                    if(alarm.time.meridiem == Meridiem.pm){
                        date.hour = alarm.time.hour + 12
                    }else{
                        date.hour = alarm.time.hour
                    }
                    date.minute = alarm.time.minute
                    date.weekday = self.weekdays()[day.rawValue]
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                    
                    let categoryId = "com.codepath17.defuge.AlarmNotificationExtension"
                    let category = UNNotificationCategory(identifier: categoryId, actions: [], intentIdentifiers: [], options: [])
                    center.setNotificationCategories([category])
                    
                    let content = UNMutableNotificationContent()
                    content.categoryIdentifier = categoryId
                    content.title = "Alarm"
                    content.body = "wakey wakey"
                    content.userInfo = ["id": alarm.id]
                    content.sound = UNNotificationSound(named: "\(alarm.tone.rawValue).mp3")

                    let request = UNNotificationRequest(identifier: "\(alarm.id)-\(String(describing: self.weekdays()[day.rawValue]))", content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: nil)
                }
            }
        }
    }
    
    func removeNotification(withIdentifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [withIdentifier])
    }
    
    func saveAlarm(alarm: Alarm) {
        
        // Remove notification for old alarm if it exists
        // Add notification for new alarm
        
        alarms.add(alarm: alarm)
        setAlarmNotification(alarm: alarm.clone())
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AlarmSegue", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlarmSegue" {
            let alarmViewController = segue.destination as! EditAlarmViewController
            alarmViewController.delegate = self
            
            var alarm = Alarm()
            alarm.time = Time.currentTime()
            
            let senderObj = sender as AnyObject
            if senderObj.description.contains("IndexPath") {
                
                let indexPath = sender as! IndexPath
                alarm = alarms.getAlarm(withIndex: indexPath.row).clone()
                
                alarmViewController.navigationItem.title = "Edit Alarm"
            }
            
            alarmViewController.alarm = alarm
        }
    }

}

