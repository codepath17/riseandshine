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



class AlarmListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, EditAlarmDelegate,SwitchCellDelegate{
    
    var alarms: StoredAlarms!
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
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
            delegate?.addAlarmToNC(alarm: alarmSelected.clone())
        }
        else {
            print("switch off")
            delegate?.removePendingAlarmFromNC(alarm: alarmSelected)
        }
    }
    
    
    @IBAction func onAddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AlarmSegue", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //alarms = StoredAlarms()
        alarms = delegate?.alarms
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveAlarm(alarm: Alarm) {
        print("saving id")
        print(alarm.id)
        alarms.setValueForAlarm(withId: alarm.id, forKey: "snoozeCount", value: 0)
        alarms.add(alarm: alarm)
        
        delegate?.removePendingAlarmFromNC(alarm: alarm)
        delegate?.addAlarmToNC(alarm: alarm.clone())
        
        tableView.reloadData()
    }
    
    func removeAlarm(alarm: Alarm) {
        self.removeAlarm(forAlarm: alarm)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        performSegue(withIdentifier: "AlarmSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.removeAlarm(withIndex: indexPath)
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
                alarmViewController.isEdit = true
            }
            
            alarmViewController.alarm = alarm
        }
    }
    
    
    func removeAlarm(forAlarm alarm: Alarm) {
        delegate?.removePendingAlarmFromNC(alarm: alarm)
        alarms.removeAlarm(withId: alarm.id)
        tableView.reloadData()
    }
    
    func removeAlarm(withIndex index: IndexPath) {
        let alarm = alarms.getAlarm(withIndex: index.row)
        delegate?.removePendingAlarmFromNC(alarm: alarm)
        alarms.removeAlarm(withIndex: index.row)
        tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
    }
}

