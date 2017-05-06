//
//  Alarm.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var timeString = "8:30:am"
    dynamic var label = ""
    dynamic var recurranceRawValues = ""
    dynamic var toneRawValue = Tone.Elegant.rawValue
    dynamic var enabled = true
    dynamic var allowSnooze = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var time: Time {
        get {
            let timeComponents = timeString.components(separatedBy: ":")
            let hour = Int(timeComponents[0])!
            let minute = Int(timeComponents[1])!
            let meridiem = Meridiem(rawValue: timeComponents[2])!
            
            return Time(withHour: hour, withMinute: minute, withMeridiem: meridiem)
        }
        
        set {
            timeString = newValue.toString()
        }
    }
    
    var recurrance: [DayOfWeek] {
        get {
            if recurranceRawValues == "" {
                return []
            }
            
            let recurranceRawVals = recurranceRawValues.components(separatedBy: ",")
            return recurranceRawVals.map({ (day: String) -> DayOfWeek in
                return DayOfWeek(rawValue: day)!
            })
        }
        set {
            var recurranceRawVals = newValue.reduce("") { (result: String, day: DayOfWeek) -> String in
                return "\(result),\(day.rawValue)"
            }
            
            if newValue.count > 0 {
                recurranceRawVals.remove(at: recurranceRawVals.startIndex)
            }
            
            recurranceRawValues = recurranceRawVals
        }
    }
    
    var tone: Tone {
        get {
            return Tone(rawValue: toneRawValue)!
        }
        set {
            toneRawValue = newValue.rawValue
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["time", "recurrance", "tone"]
    }
    
    func clone() -> Alarm {
        let alarmClone = Alarm()
        
        alarmClone.id = id
        alarmClone.timeString = timeString
        alarmClone.label = label
        alarmClone.recurranceRawValues = recurranceRawValues
        alarmClone.toneRawValue = toneRawValue
        alarmClone.enabled = enabled
        alarmClone.allowSnooze = allowSnooze
        
        return alarmClone
    }
}
