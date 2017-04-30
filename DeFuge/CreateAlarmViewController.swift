//
//  CreateAlarmViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/28/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

protocol CreateAlarmDelegate {
    func saveAlarm(alarm: Alarm)
}

class CreateAlarmViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, SelectListDelegate {
    
    var alarm: Alarm!
    var delegate: CreateAlarmDelegate!
    
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var alarmLabelField: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBAction func onSnoozeSwitch(_ sender: UISwitch) {
        alarm.allowSnooze = sender.isOn
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "SelectListSegue", sender: sender)
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        delegate.saveAlarm(alarm: alarm)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        selectPickerValues()
        
        snoozeSwitch.isOn = alarm.allowSnooze
        
        alarmLabelField.delegate = self
        
        setRepeatLabel()
        
        soundLabel.text = alarm.tone.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
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
            alarm.time.hour = rowToHour(row: row)
            
            let merideimRow = ((row + 1) % 24) > 11 ? 1 : 0
            pickerView.selectRow(merideimRow, inComponent: 2, animated: true)
            
            alarm.time.meridiem = rowToMerideim(row: merideimRow)
        } else if component == 1 {
            alarm.time.minute = rowToMintute(row: row)
        } else if component == 2 {
            alarm.time.meridiem = rowToMerideim(row: row)
            
            let hourRow = pickerView.selectedRow(inComponent: 0) + 12
            pickerView.selectRow(hourRow, inComponent: 0, animated: false)
        }        
    }
    
    func selectPickerValues() {
        let meridiem = alarm.time.meridiem!
        
        var hourRow = 300 + alarm.time.hour! - 1
        var meridiemRow = 1
        
        if (meridiem == Meridiem.am) {
            hourRow -= 12
            meridiemRow = 0
        }
        
        let minuteRow = 300 + alarm.time.minute!
        
        timePickerView.selectRow(hourRow, inComponent: 0, animated: false)
        timePickerView.selectRow(minuteRow, inComponent: 1, animated: false)
        timePickerView.selectRow(meridiemRow, inComponent: 2, animated: false)
    }
    
    //TODO: fix text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        alarm.label = textField.text
    }
    
    func setRepeatLabel() {
        
        let recurrance = alarm.recurrance
        
        var repeatString = recurrance.reduce("") { (result: String, day: DayOfWeek) -> String in
            let dayString = day.rawValue
            let strIndex = dayString.index(dayString.startIndex, offsetBy: 3)
            
            return "\(result) \(dayString.substring(to: strIndex))"
        }
        
        if recurrance.count == 7 {
            repeatString = "Everyday"
        } else if recurrance.count == 5 {
            if (recurrance.contains(DayOfWeek.Monday)
                && recurrance.contains(DayOfWeek.Tuesday)
                && recurrance.contains(DayOfWeek.Wednesday)
                && recurrance.contains(DayOfWeek.Thursday)
                && recurrance.contains(DayOfWeek.Friday)) {
                
                repeatString = "Weekdays"
            }
        } else if recurrance.count == 2 {
            if (recurrance.contains(DayOfWeek.Saturday)
                && recurrance.contains(DayOfWeek.Sunday)) {
                
                repeatString = "Weekends"
            }
        } else if recurrance.count == 0 {
            repeatString = "Never"
        }
        
        repeatLabel.text = repeatString
    }
    
    func getAllDaysofWeek() -> [String]{
        return [
            DayOfWeek.Sunday.rawValue,
            DayOfWeek.Monday.rawValue,
            DayOfWeek.Tuesday.rawValue,
            DayOfWeek.Wednesday.rawValue,
            DayOfWeek.Thursday.rawValue,
            DayOfWeek.Friday.rawValue,
            DayOfWeek.Saturday.rawValue
        ]
    }
    
    func getAllTones() -> [String] {
        return [
            Tone.Elegant.rawValue
        ]
    }
    
    func updateSelected(listType type: String, selectedValues values: [String]) {
        if type == "Repeat" {
            alarm.recurrance = values.map({ (value: String) -> DayOfWeek in
                return DayOfWeek(rawValue: value)!
            })
            
            setRepeatLabel()
        } else if type == "Sound" {
            let value = values[0]
            alarm.tone = Tone(rawValue: value)!
            soundLabel.text = value
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SelectListSegue" {
            let selectListController = segue.destination as! SelectListViewController
            selectListController.delegate = self
            
            let gesture = sender as! UITapGestureRecognizer
            let viewTag  = gesture.view?.tag
            
            if viewTag == 0 {
                selectListController.navItem.title = "Repeat"
                selectListController.selected = alarm.recurrance.map({ (day: DayOfWeek) -> String in
                    day.rawValue
                })
                
                selectListController.options = getAllDaysofWeek()
            } else {
                selectListController.navItem.title = "Sound"
                selectListController.multiSelect = false
                selectListController.selected = [alarm.tone.rawValue]
                selectListController.options = getAllTones()
            }
        }
    }

}
