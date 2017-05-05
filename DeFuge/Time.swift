//
//  Time.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/28/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation

class Time {
    let hour: Int
    let minute: Int
    let meridiem: Meridiem
    
    init(withHour hour: Int, withMinute minute: Int, withMeridiem meridiem: Meridiem) {
        self.hour = hour
        self.minute = minute
        self.meridiem = meridiem
    }
    
    func toString() -> String {
        return "\(hour):\(minute):\(meridiem)"
    }
    
    static func currentTime() -> Time {
        let currentTime = Date()
        let calendar = Calendar.current
        
        var hour = calendar.component(.hour, from: currentTime)
        var meridiem = Meridiem.am
        
        if hour > 12 {
            hour -= 12
            meridiem = Meridiem.pm
        }
        
        var minute = calendar.component(.minute, from: currentTime)
        
        if minute > 59 {
            hour += 1
            minute -= 60
        }
        
        return Time(withHour: hour, withMinute: minute, withMeridiem: meridiem)
    }
}

