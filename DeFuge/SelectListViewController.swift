//
//  SelectListViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/30/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

protocol SelectListDelegate {
    func updateSelected(listType type: String, selectedValues values: [String])
}

class SelectListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var multiSelect = true
    var options: [String]!
    var selected: [String]!
    var delegate: SelectListDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        delegate.updateSelected(listType: navItem.title!, selectedValues: selected)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
        let value = options[indexPath.row]
        
        cell.valueLabel.text = value
        if selected.contains(value) {
            cell.checkMarkLabel.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selectedValue = options[indexPath.row]
        let selectedCell = tableView.cellForRow(at: indexPath) as! SelectCell
        
        if multiSelect {
            
            if selected.contains(selectedValue) {
                selected.remove(at: selected.index(of: selectedValue)!)
                selectedCell.checkMarkLabel.isHidden = true
            } else {
                selected.append(selectedValue)
                selectedCell.checkMarkLabel.isHidden = false
            }
        } else {
            let oldSelectedRow = options.index(of: selected.first!)
            
            if oldSelectedRow != indexPath.row {
                let oldSelectedIndexPath = IndexPath(row: oldSelectedRow!, section: 0)
                let oldSelectedCell = tableView.cellForRow(at: oldSelectedIndexPath) as! SelectCell
                oldSelectedCell.checkMarkLabel.isHidden = true
                selected.removeAll()
                
                selectedCell.checkMarkLabel.isHidden = false
                selected.append(selectedValue)
            }
        }
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
