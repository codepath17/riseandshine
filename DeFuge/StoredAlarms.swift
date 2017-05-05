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
    
    func getAlaram(withId id: String) -> Alarm? {
        return alarms.first(where: { (alarm: Alarm) -> Bool in
            return alarm.id == id
        })
    }
    
    func add(alarm: Alarm) {
        try! realm.write {
            realm.add(alarm, update: true)
        }
    }
}
