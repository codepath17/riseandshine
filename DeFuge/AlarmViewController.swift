//
//  AlarmViewController.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 5/5/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import CoreMotion

//TODO: Add to app settings
let MAX_STEP_COUNT = 50

class AlarmViewController: UIViewController {
    
    var alarm: Alarm!
    private var clockTimer: Timer!
    private let pedometer = CMPedometer()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    @IBOutlet weak var progressBarView: ProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if alarm.snoozeCount > 2 {
            snoozeButton.isHidden = true
        }
        
        // Do any additional setup after loading the view.
        
        // TODO: get max step count from settings
        progressBarView.max = MAX_STEP_COUNT
        
        var alarmLabel = "Alarm"
        /* if alarm.label != "" {
         alarmLabel = alarm.label
         }*/
        alarmNameLabel.text = alarmLabel
        
        updateTimeLabel()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) in
            self.updateTimeLabel()
        })
        
        if(CMPedometer.isStepCountingAvailable()) {
            let fromTime = TimeUtil.add(minutes: alarm.snoozeCount * 10, toTime: alarm.time)
            let fromDate = TimeUtil.getCurrentDate(fromTime: fromTime)
            
            pedometer.startUpdates(from: fromDate, withHandler: { (data, error) in
                DispatchQueue.main.sync(execute: {
                    if(error == nil){
                        if let stepCount = data?.numberOfSteps {
                            let progress = Int(stepCount)
                            self.progressBarView.progress = Int(progress)
                            
                            if progress >= MAX_STEP_COUNT {
                                //Stop alarm
                                self.delegate?.stopMusic()
                                self.delegate?.util.getAlarms().setValueForAlarm(withId: self.alarm.id, forKey: "snoozeCount", value: 0)
                                self.performSegue(withIdentifier: "AlarmListSegue", sender: self)
                            }
                        }
                    }
                })
            })
        }
        
        /* if !alarm.allowSnooze {
         snoozeButton.isHidden = true
         }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        progressBarView.contentView.backgroundColor = view.backgroundColor
        progressBarView.progressMessageLabel.textColor = UIColor.white
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
        
        if(CMPedometer.isStepCountingAvailable()) {
            pedometer.stopUpdates()
        }
    }
    
    @IBAction func onSnoozeButtonClick(_ sender: UIButton) {
        delegate?.snoozeMusic(alarm: alarm)
        self.performSegue(withIdentifier: "AlarmListSegue", sender: self)
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
