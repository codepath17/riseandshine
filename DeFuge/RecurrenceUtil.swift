//
//  RecurrenceUtil.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/30/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation

class RecurrenceUtil: NSObject {
    static func toShortString(fromRecurrenceArray recurrenceArray: [DayOfWeek], annotateNever never: Bool) -> String {
        var repeatString = recurrenceArray.reduce("") { (result: String, day: DayOfWeek) -> String in
            let dayString = day.rawValue
            let strIndex = dayString.index(dayString.startIndex, offsetBy: 3)
            
            return "\(result) \(dayString.substring(to: strIndex))"
        }
        
        if recurrenceArray.count == 7 {
            repeatString = "Everyday"
        } else if recurrenceArray.count == 5 {
            if (recurrenceArray.contains(DayOfWeek.Monday)
                && recurrenceArray.contains(DayOfWeek.Tuesday)
                && recurrenceArray.contains(DayOfWeek.Wednesday)
                && recurrenceArray.contains(DayOfWeek.Thursday)
                && recurrenceArray.contains(DayOfWeek.Friday)) {
                
                repeatString = "Weekdays"
            }
        } else if recurrenceArray.count == 2 {
            if (recurrenceArray.contains(DayOfWeek.Saturday)
                && recurrenceArray.contains(DayOfWeek.Sunday)) {
                
                repeatString = "Weekends"
            }
        } else if (recurrenceArray.count == 0 && never){
            repeatString = "Never"
        }
        
        return repeatString
    }
}
