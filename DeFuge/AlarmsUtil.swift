//
//  AlarmsUtil.swift
//  DeFuge
//
//  Created by Doshi, Nehal on 5/11/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class AlarmsUtil: AlarmListUtilDelegate {
    var alarms: StoredAlarms!
    
    init(){
        alarms = StoredAlarms()
    }
    
    func getAlarm(alarmId: String) -> Alarm{
        return alarms.getAlarm(withId: alarmId)!.clone()
    }
    
    func getAlarms() -> StoredAlarms{
        return alarms
    }
}
