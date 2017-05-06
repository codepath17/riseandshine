//
//  AlarmViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 5/5/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    var alarm: Alarm!
    private var timer: Timer!
    
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var alarmLabel = "Alarm"
        if alarm.label != "" {
            alarmLabel = alarm.label
        }
        alarmNameLabel.text = alarmLabel
        
        updateTimeLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) in
            self.updateTimeLabel()
        })
        
        if !alarm.allowSnooze {
            snoozeButton.isHidden = true
        }
    }
    
    func updateTimeLabel() {
        let currentTime = Time.currentTime()
        let minuteString = String(format: "%02d", currentTime.minute)
        self.timeLabel.text = "\(currentTime.hour):\(minuteString) \(currentTime.meridiem.rawValue)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
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
