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

class AlarmListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, EditAlarmDelegate, UNUserNotificationCenterDelegate,SwitchCellDelegate{
    
    var alarms: StoredAlarms!
    
    private var tableCellRowInitialCenter: CGPoint?
    private var origTableCellLeftConstraint: CGFloat?
    private var origTableCellRightConstraint: CGFloat?
    private var origCellBackgroundColor: UIColor?
    
    @IBOutlet weak var tableView: UITableView!
    
    func switchCell(switchCell: AlarmCell, didChangeValue value:Bool){
        
        let indexPath = tableView.indexPath(for: switchCell)!
        let alarmSelected: Alarm = alarms.getAlarm(withIndex: indexPath.row)
        alarms.setValueForAlarm(withId: alarmSelected.id, forKey: "enabled", value: value)
        
        if value {
            print("switch on")
            addAlarmToNC(alarm: alarmSelected.clone())
            tableView.reloadData()
        }
        else {
            print("switch off")
            removePendingAlarmFromNC(withAlarmId: alarmSelected.id)
            tableView.reloadData()
        }
    }
    
    
    @IBAction func onAddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AlarmSegue", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
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
    
    func addAlarmToNC(alarm: Alarm){
        // ask permission for notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (authorized, error) in
            if authorized {
                print("access granted, proceed")
                
                if(alarm.recurrance.count > 0){
                    for day in alarm.recurrance {
                        self.addNotificationRequestToNC(alarm: alarm, weekday: day)
                    }
                }else{
                    self.addNotificationRequestToNC(alarm: alarm, weekday: nil)
                }
            }
        }
    }
    
    func removePendingAlarmFromNC(withAlarmId: String) {
        if let alarm = alarms.getAlaram(withId: withAlarmId){
            if(alarm.recurrance.count > 0){
                for day in (alarm.recurrance) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: (alarm.id), weekday: self.weekdays()[day.rawValue]!)])
                }
            }else{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: (alarm.id), weekday: nil)])
            }
        }
    }
    
    func addNotificationRequestToNC(alarm: Alarm, weekday: DayOfWeek?){
        let center = UNUserNotificationCenter.current()
        var repeats = false
        var notificationRequestIdentifier : String
        
        var date = DateComponents()
        
        if(alarm.time.meridiem == Meridiem.pm){
            date.hour = alarm.time.hour + 12
        }else{
            date.hour = alarm.time.hour
        }
        date.minute = alarm.time.minute
        if(weekday != nil){
            let dayNumber = self.weekdays()[weekday!.rawValue]
            date.weekday = dayNumber
            repeats = true
            notificationRequestIdentifier = RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: alarm.id, weekday: dayNumber)
        }else{
            notificationRequestIdentifier = RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: alarm.id, weekday: nil)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        let snoozeAction = UNNotificationAction(
            identifier: "snooze",
            title: "Snooze 10 Minutes",
            options: [UNNotificationActionOptions.destructive])
        
        let dismissAction = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: [])
        var actions : [UNNotificationAction]
        
        if(alarm.allowSnooze){
            actions = [snoozeAction,dismissAction]
        }else{
            actions = [dismissAction]
        }
        
        let categoryId = "com.codepathgroup17.defuge.AlarmNotificationExtension"
        let category = UNNotificationCategory(identifier: categoryId, actions: actions, intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryId
        content.title = "Alarm"
        content.body = "wakey wakey"
        content.userInfo = ["id": alarm.id]
       // content.sound = UNNotificationSound(named: "\(alarm.tone.rawValue).mp3")
        
        let request = UNNotificationRequest(identifier: notificationRequestIdentifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    func saveAlarm(alarm: Alarm) {
        alarms.setValueForAlarm(withId: alarm.id, forKey: "snoozeCount", value: 0)
        alarms.add(alarm: alarm)
        
        removePendingAlarmFromNC(withAlarmId: alarm.id)
        addAlarmToNC(alarm: alarm.clone())
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        let alarm = alarms.getAlarm(withIndex: indexPath.row)
        
        if(alarm.recurrance.count == 0){
            alarms.setValueForAlarm(withId: alarm.id, forKey: "enabled", value: false)
        }
        cell.alarm = alarm
        cell.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onTableRowSwipe(sender:)))
        cell.addGestureRecognizer(panGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AlarmSegue", sender: indexPath)
    }

    func onTableRowSwipe(sender: UIPanGestureRecognizer) {
        let cell = sender.view as! AlarmCell
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            origTableCellLeftConstraint = cell.containerViewLeadingEdgeConstraint.constant
            origTableCellRightConstraint = cell.containerViewTrailingEdgeConstraint.constant
            print("swipe begin")
        } else if sender.state == .changed {
            if velocity.x < 0 {
                print("swiping left")
                UIView.animate(withDuration: 0.3) {
                    cell.containerViewLeadingEdgeConstraint.constant = self.origTableCellLeftConstraint! + translation.x
                    cell.containerViewTrailingEdgeConstraint.constant = self.origTableCellRightConstraint! - translation.x
                    cell.contentView.backgroundColor = UIColor.red
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: { 
                    cell.containerViewLeadingEdgeConstraint.constant = 0
                    cell.containerViewTrailingEdgeConstraint.constant = 0
                    cell.contentView.backgroundColor = UIColor.clear
                })
            }
            
        } else if sender.state == .ended {
            if velocity.x < 0 && abs(translation.x) > cell.frame.width / 2 {
                print("done left more than 1/2")
                UIView.animate(withDuration: 0.3, animations: {
                    cell.containerViewLeadingEdgeConstraint.constant = 0
                    cell.containerViewTrailingEdgeConstraint.constant = -1 * cell.frame.width
                }, completion: { (done: Bool) in
                    cell.containerViewLeadingEdgeConstraint.constant = self.origTableCellLeftConstraint!
                    cell.containerViewTrailingEdgeConstraint.constant = self.origTableCellRightConstraint!
                    cell.contentView.backgroundColor = self.origCellBackgroundColor
                    
                    let alarmIndex = self.tableView.indexPath(for: cell)!.row
                    self.removeAlarm(withIndex: alarmIndex)
                    
                    self.origTableCellLeftConstraint = nil
                    self.origTableCellRightConstraint = nil
                })
            } else {
                print("done swipe reset")
                UIView.animate(withDuration: 0.3, animations: {
                    cell.containerViewLeadingEdgeConstraint.constant = 0
                    cell.containerViewTrailingEdgeConstraint.constant = 0
                    cell.contentView.backgroundColor = UIColor.clear
                }, completion: { (done: Bool) in
                    self.origTableCellLeftConstraint = nil
                    self.origTableCellRightConstraint = nil
                })
            }
        }
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //this can play music longer and is an alternative to UNNotificationSound
        AVPlayerUtil.playMusic("Elegant")
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        let request = response.notification.request
        
        if identifier == "snooze"{
            //TODO do snooze action here
            
            if let id = request.content.userInfo["id"] as? String {
                print(id)
            }
        }
        if identifier == "dismiss"{
            //TODO play avplayer here
            if let id = request.content.userInfo["id"] as? String {
                print(id)
                AVPlayerUtil.stopMusic()
            }
        }
        completionHandler()
    }
    

    func removeAlarm(withIndex index: Int) {
        let alarm = alarms.getAlarm(withIndex: index)
        removePendingAlarmFromNC(withAlarmId: alarm.id)
        
        alarms.removeAlarm(withIndex: index)
        tableView.reloadData()
    }
}

