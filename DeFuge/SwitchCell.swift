//
//  SwitchCell.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/30/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var onOffSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
