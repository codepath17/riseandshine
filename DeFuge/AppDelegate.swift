//
//  AppDelegate.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 4/27/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import UserNotifications


protocol AlarmListUtilDelegate {
    func getAlarm(alarmId: String) -> Alarm
    func getAlarms() -> StoredAlarms
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,AVAudioPlayerDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var alarms: StoredAlarms!
    var util: AlarmListUtilDelegate = AlarmsUtil()
    var currentAlarm: Alarm?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // TODO: determine if alarm view is to be shown
        // set true to show alarm view
        alarms = self.util.getAlarms()
        var error: NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error1 as NSError{
            error = error1
            print("could not set session. err:\(error!.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error1 as NSError{
            error = error1
            print("could not active session. err:\(error!.localizedDescription)")
        }
        window?.tintColor = UIColor.red
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
         var actions : [UNNotificationAction]
        let snoozeAction = UNNotificationAction(
            identifier: "snooze",
            title: "Snooze 10 Minutes",
            options: [UNNotificationActionOptions.destructive])
        
        let dismissAction = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: [])
        actions = [snoozeAction,dismissAction]

        let categoryId = "com.codepathgroup17.defuge.AlarmNotificationExtension"
        let category = UNNotificationCategory(identifier: categoryId, actions: actions, intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])

        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let sound = notification.request.content.userInfo["sound"]
        playMusic(sound as! String)
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("un center")
        var returnVal:Bool = false
        var alarm:Alarm!
        var identifier = response.actionIdentifier
        let request = response.notification.request
        
        if identifier == "snooze"{
            
            if let id = request.content.userInfo["id"] as? String {
                print(id)
                alarm = util.getAlarm(alarmId: id) as Alarm
                returnVal = snoozeMusic(alarm: alarm)
            }
        }
        if identifier == "dismiss"{
            
            if let id = request.content.userInfo["id"] as? String {
                print(id)
                AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
                stopMusic()
            }
        }
        if let id = request.content.userInfo["id"] as? String {
            print(id)
            alarm = util.getAlarm(alarmId: id) as Alarm
            identifier = "none"
        }

        completionHandler()
        
        if (returnVal == true || identifier == "none" ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
       
        vc.alarm = alarm
        
        window?.rootViewController = vc
        }
    }
    func weekdays() -> [String: Int] {
        return [
            DayOfWeek.Sunday.rawValue: 1,
            DayOfWeek.Monday.rawValue: 2,
            DayOfWeek.Tuesday.rawValue: 3,
            DayOfWeek.Wednesday.rawValue: 4,
            DayOfWeek.Thursday.rawValue: 5,
            DayOfWeek.Friday.rawValue: 6,
            DayOfWeek.Saturday.rawValue: 7,
        ]
    }

    func playMusic(_ soundName: String) {
        
        
            //vibrate phone first
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            //set vibrate callback
            AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
                                                  nil,
                                                  { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                                                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            },
                                                  nil)
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
            
            var error: NSError?
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            } catch let error1 as NSError {
                error = error1
                audioPlayer = nil
            }
            
            if let err = error {
                print("audioPlayer error \(err.localizedDescription)")
                return
            } else {
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
            }
            
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.play()
        }
        
    
    
    func stopMusic(){
        audioPlayer?.stop()
    }

    func snoozeMusic(alarm:Alarm) -> Bool{
        
        
        var count = alarm.snoozeCount
        if count < 3 {
            stopMusic()
            count = count + 1
            alarms.setValueForAlarm(withId: alarm.id,forKey: "snoozeCount",value: count)
            removePendingAlarmFromNC(alarm: alarm)
            
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let now = Date()
            let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 1, to: now, options:.matchStrictly)!
            //let newCalendar = Calendar.current()
            var hour = calendar.component(.hour, from: snoozeTime)
            let minute = calendar.component(.minute, from: snoozeTime)
            if hour > 12 {
                hour -= 12
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "a"
            let meri = formatter.string(from: snoozeTime)
            print(meri)
            var meridiemVal = Meridiem.pm;
            if meri.caseInsensitiveCompare("am") == ComparisonResult.orderedSame{
                meridiemVal = Meridiem.am
            }
            
            let time = Time(withHour: hour, withMinute: minute, withMeridiem: meridiemVal)
            
            alarms.setValueForAlarm(withId: (alarm.id), forKey: "time", value: time)
            addAlarmToNC(alarm: alarm)
        
            return true
        }
        else{
            print("Sorry can't stop music , start walking")
            //temp call to stop music - REMOVE
            stopMusic()
            //pedometer count complete should call stopmusic??
            //add seque to goto alarmlistview
            return false
        }

    }
    
    func addNotificationRequestToNC(alarm: Alarm, weekday: DayOfWeek?){
        let center = UNUserNotificationCenter.current()
       // center.delegate = self
        var repeats = false
        var notificationRequestIdentifier : String
        
        var date = DateComponents()
        
        if(alarm.time.meridiem == Meridiem.pm){
            date.hour = alarm.time.hour + 12
        }else{
            date.hour = alarm.time.hour
        }
        date.minute = alarm.time.minute
        if(weekday != nil){
            let dayNumber = self.weekdays()[weekday!.rawValue]
            date.weekday = dayNumber
            repeats = true
            notificationRequestIdentifier = RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: alarm.id, weekday: dayNumber)
        }else{
            notificationRequestIdentifier = RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: alarm.id, weekday: nil)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        
        let categoryId = "com.codepathgroup17.defuge.AlarmNotificationExtension"
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryId
        content.title = "Alarm"
        content.body = "wakey wakey"
        content.userInfo = ["id": alarm.id,"sound": "\(alarm.tone.rawValue)"]
        content.sound = UNNotificationSound(named: "\(alarm.tone.rawValue)")
        let request = UNNotificationRequest(identifier: notificationRequestIdentifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
        
        /* let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
         let request1 = UNNotificationRequest(identifier: notificationRequestIdentifier, content: content, trigger: trigger1)
         center.add(request1, withCompletionHandler: nil)*/

        
    }

    func addAlarmToNC(alarm: Alarm){
        
        if(alarm.recurrance.count > 0){
            for day in alarm.recurrance {
              addNotificationRequestToNC(alarm: alarm, weekday: day)
            }
        }else{
            addNotificationRequestToNC(alarm: alarm, weekday: nil)
        }
       
    }
    
    func removePendingAlarmFromNC(alarm: Alarm) {
        
            if(alarm.recurrance.count > 0){
                for day in (alarm.recurrance) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: (alarm.id), weekday: weekdays()[day.rawValue]!)])
                }
            }else{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [RecurrenceUtil.toNotificationIdentifierFromAlarm(alarmId: (alarm.id), weekday: nil)])
            }
        
    }
    
    
  

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("app resign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("app active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("app terminate")
    }


}

