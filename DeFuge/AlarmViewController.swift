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
    private var clockTimer: Timer!
    
    //TODO: remove once pedometer is integrated
    private var tempAnimationTimer1: Timer!
    private var tempAnimationTimer2: Timer!
    private var tempAnimationTimer3: Timer!
    private var tempAnimationTimer4: Timer!
    
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    @IBOutlet weak var progressBarView: ProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // TODO: get max step count from settings
        progressBarView.max = 50
        
        var alarmLabel = "Alarm"
        if alarm.label != "" {
            alarmLabel = alarm.label
        }
        alarmNameLabel.text = alarmLabel
        
        updateTimeLabel()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) in
            self.updateTimeLabel()
        })
        
        //TODO: remove once pedometer is integrated
        // Pedometer simulation starts here
        tempAnimationTimer1 = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer: Timer) in
            self.progressBarView.progress = 10
        })
        
        tempAnimationTimer2 = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { (timer: Timer) in
            self.progressBarView.progress = 25
        })
        
        tempAnimationTimer3 = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (timer: Timer) in
            self.progressBarView.progress = 45
        })
        
        tempAnimationTimer4 = Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { (timer: Timer) in
            self.progressBarView.progress = 60
        })
        // Pedometer simulation ends here
        
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
        
        clockTimer.invalidate()
        
        //TODO: remove once pedometer is integrated
        tempAnimationTimer1.invalidate()
        tempAnimationTimer2.invalidate()
        tempAnimationTimer3.invalidate()
        tempAnimationTimer4.invalidate()
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