//
//  ListSelectorCell.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/29/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class ListSelectorCell: UITableViewCell {
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var valuesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
