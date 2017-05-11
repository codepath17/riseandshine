//
//  AVPlayerUtil.swift
//  DeFuge
//
//  Created by Doshi, Nehal on 5/8/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import UserNotifications

class AVPlayerUtil: NSObject  {
    static var audioPlayer: AVAudioPlayer?

    override init(){
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

    }
    static func playMusic(_ soundName: String) {
        
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
        
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
    static func stopMusic(){
        self.audioPlayer?.stop()
    }

}
