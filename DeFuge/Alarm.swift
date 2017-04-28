//
//  Alarm.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import Foundation

class Alarm: NSObject {
    
    var time: Date = Date()
    var label: String!
    var recurrance: [DayOfWeek]!
    var tone: Tone = Tone.Elegant
    var enabled: Bool = true
}
