//
//  Time.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/28/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation

class Time: NSObject {
    var hour: Int?
    var minute: Int?
    var meridiem: Meridiem?
    
    init(withHour hour: Int, withMinute minute: Int, withMeridiem meridiem: Meridiem) {
        self.hour = hour
        self.minute = minute
        self.meridiem = meridiem
    }
}
