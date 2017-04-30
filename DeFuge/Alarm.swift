//
//  Alarm.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation

class Alarm: NSObject {
    
    var time: Time!
    var label: String?
    var recurrance: [DayOfWeek] = []
    var tone: Tone = Tone.Elegant
    var enabled: Bool = true
    var allowSnooze: Bool = true
    
    override init() {
        super.init()
        
        let currentTime = Date()
        let calendar = Calendar.current
        
        var hour = calendar.component(.hour, from: currentTime)
        var meridiem = Meridiem.am
        
        if hour > 12 {
            hour -= 12
            meridiem = Meridiem.pm
        }
        
        var minute = calendar.component(.minute, from: currentTime) + 5
        
        if minute > 59 {
            hour += 1
            minute -= 60
        }
        
        time = Time(withHour: hour, withMinute: minute, withMeridiem: meridiem)
    }
}
