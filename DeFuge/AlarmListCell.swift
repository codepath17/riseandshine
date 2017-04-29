//
//  AlarmListCell.swift
//  DeFuge
//
//  Created by Doshi, Nehal on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class AlarmListCell: UITableViewCell {

    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var alarmDesc: UILabel!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
