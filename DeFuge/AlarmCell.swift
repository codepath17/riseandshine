//
//  AlarmCell.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/30/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: AlarmCell, didChangeValue value:Bool)
}

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recurrenceLabel: UILabel!
    @IBOutlet weak var containerViewLeadingEdgeConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingEdgeConstraint: NSLayoutConstraint!
    
     weak var delegate: SwitchCellDelegate?
    
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
         enableSwitch.addTarget(self, action: #selector(self.switchValueChanged), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged(){
        print("switch value changed")
        if delegate != nil {
            self.delegate?.switchCell?(switchCell: self,didChangeValue: enableSwitch.isOn)
        }
    }
}
