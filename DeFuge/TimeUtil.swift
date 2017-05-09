//
//  TimeUtil.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 5/8/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation

class TimeUtil {
    
    static func getCurrentDate(fromTime time: Time) -> Date {
        var hour = time.hour
        if time.meridiem == .pm {
            hour += 12
        }
        
        let currentCalendar = Calendar.current
        var components = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        components.hour = hour
        components.minute = time.minute
        
        return currentCalendar.date(from: components)!
    }
    
    static func add(minutes: Int, toTime time: Time) -> Time {
        var meridiem = time.meridiem
        var hour = time.hour
        var minute = time.minute + minutes
        
        if minute > 50 {
            minute -= 60
            hour = hour + 1
        }
        
        if hour > 12 {
            hour = 1
            meridiem = meridiem == .am ? .pm : .am
        }
        
        return Time(withHour: hour, withMinute: minute, withMeridiem: meridiem)
    }
}
