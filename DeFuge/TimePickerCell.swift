//
//  TimePickerCell.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/28/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var time: Time! {
        didSet {
            selectPickerValues()
        }
    }
    
    @IBOutlet weak var timePickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 2
        }
        
        return 600
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(rowToHour(row: row))
        } else if component == 1 {
            return String(format: "%02d", rowToMintute(row: row))
        } else if component == 2 {
            return rowToMerideim(row: row).rawValue
        }
        
        return nil
    }
    
    func rowToHour(row: Int) -> Int {
        return (row % 12) + 1
    }
    
    func rowToMintute(row: Int) -> Int {
        return row % 60
    }
    
    func rowToMerideim(row: Int) -> Meridiem {
        var merideim = Meridiem.am
        
        if row == 1 {
            merideim = Meridiem.pm
        }
        
        return merideim
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            time.hour = rowToHour(row: row)
            
            let merideimRow = ((row + 1) % 24) > 11 ? 1 : 0
            pickerView.selectRow(merideimRow, inComponent: 2, animated: true)
            
            time.meridiem = rowToMerideim(row: merideimRow)
        } else if component == 1 {
            time.minute = rowToMintute(row: row)
        } else if component == 2 {
            time.meridiem = rowToMerideim(row: row)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
    }
    
    func selectPickerValues() {
        let hourRow = 300 + time.hour! - 1
        let minuteRow = 300 + time.minute!
        let meridiemRow = time.meridiem == Meridiem.am ? 0 : 1
        
        timePickerView.selectRow(hourRow, inComponent: 0, animated: false)
        timePickerView.selectRow(minuteRow, inComponent: 1, animated: false)
        timePickerView.selectRow(meridiemRow, inComponent: 2, animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
