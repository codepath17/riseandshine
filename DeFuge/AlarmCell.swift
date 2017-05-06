//
//  AlarmCell.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/30/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recurrenceLabel: UILabel!
    
    var alarm: Alarm! {
        didSet {
            let minuteString = String(format: "%02d",alarm.time.minute)
            timeLabel.text = "\(alarm.time.hour):\(minuteString) \(alarm.time.meridiem.rawValue)"
            
            enableSwitch.isOn = alarm.enabled
            nameLabel.text = "Alarm"
            
            let alarmLabel = alarm.label
            if alarmLabel != "" {
                nameLabel.text = alarmLabel
            }
            
            recurrenceLabel.text = RecurrenceUtil.toShortString(fromRecurrenceArray: alarm.recurrance, annotateNever: false)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
