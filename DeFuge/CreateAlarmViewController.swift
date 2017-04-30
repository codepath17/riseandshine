//
//  CreateAlarmViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/28/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class CreateAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alarm: Alarm!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarm = Alarm()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell?
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.time = Time(withHour: 3, withMinute: 15, withMeridiem: .pm)
            tableCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListSelectorCell", for: indexPath) as! ListSelectorCell
            cell.settingLabel.text = "Repeat"
            cell.valuesLabel.text = "Mon, Tue, Wed"
            tableCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListSelectorCell", for: indexPath) as! ListSelectorCell
            cell.settingLabel.text = "Sound"
            cell.valuesLabel.text = "Elegant"
            tableCell = cell
        default:
            tableCell = UITableViewCell()
        }
        
        return tableCell!
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
