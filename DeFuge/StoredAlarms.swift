//
//  StoredAlarms.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 5/4/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation
import RealmSwift

class StoredAlarms {
    private let alarms: Results<Alarm>
    private let realm: Realm
    
    var count: Int {
        get{
            return alarms.count
        }
    }
    
    init() {
        // Get the default Realm
        realm = try! Realm()
        // Query Realm for all alarms
        alarms = realm.objects(Alarm.self)
    }
    
    func getAlarm(withIndex index: Int) -> Alarm {
        return alarms[index]
    }
    
    func getAlarm(withId id: String) -> Alarm? {
        return alarms.first(where: { (alarm: Alarm) -> Bool in
            return alarm.id == id
        })
    }
    
    func add(alarm: Alarm) {
        try! realm.write {
            realm.add(alarm, update: true)
        }
    }
    
    func setValueForAlarm(withId id: String, forKey key: String, value: Any) {
        if let alarm = getAlarm(withId: id) {
            try! realm.write {
                switch key {
                case "label":
                    alarm.label = value as! String
                case "enabled":
                    alarm.enabled = value as! Bool
                case "allowSnooze":
                    alarm.allowSnooze = value as! Bool
                case "time":
                    alarm.time = value as! Time
                case "recurrance":
                    alarm.recurrance = value as! [DayOfWeek]
                case "tone":
                    alarm.tone = value as! Tone
                case "snoozeCount":
                    alarm.snoozeCount = value as! Int
                default: break
                }
            }
        }
    }
    
    func removeAlarm(withIndex index: Int) {
        let alarm = getAlarm(withIndex: index)
        try! realm.write {
            realm.delete(alarm)
        }
    }
    
    func removeAlarm(withId id: String) {
        let alarm = getAlarm(withId: id)
        try! realm.write {
            realm.delete(alarm!)
        }
    }
}
