//
//  InitialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import AVFoundation

// Global but private (Works like a static variable in objective-c). To avoid a "wall of sound" or many copies of the same music
private var backgroundMusicPlayer: AVAudioPlayer!

class InitialViewController: UIViewController {
    
    private var musicOn: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.MusicOn)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserDefaultsKey.MusicOn)
            if newValue {
                if !backgroundMusicPlayer.playing { backgroundMusicPlayer.play() }
            } else {
                if backgroundMusicPlayer.playing { backgroundMusicPlayer.stop() }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        audioSetup()
        updateUI()
    }

    private func updateUI()
    {
        // Music On/Off Button
        let musicOn = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.MusicOn)
        let musicOnImage = UIImage(named: musicOn ? Filename.MusicOn : Filename.MusicOff)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        musicOnButton.setImage(UIImage(named: musicOn ? Filename.MusicOn : Filename.MusicOff), forState: UIControlState.Normal)
    }
    
    @IBOutlet weak var musicOnButton: UIButton!
    @IBAction func musicOnButtonPressed(sender: AnyObject) {
        musicOn = !musicOn
        updateUI()
    }
    
    private func audioSetup()
    {
        // setup background music
        if backgroundMusicPlayer == nil {
            if let backgroundMusicURL = NSBundle.mainBundle().URLForResource(Filename.BackgroundMusicInitial, withExtension: nil) {
                backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: nil)
                backgroundMusicPlayer.numberOfLoops = -1
            }
        }
        if !backgroundMusicPlayer.playing && musicOn {
            backgroundMusicPlayer.play()
        }
    }
    
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueId = segue.identifier {
            switch segueId {
            case SegueId.StartGame:
                backgroundMusicPlayer.stop()
                backgroundMusicPlayer = nil
            default:
                break
            }
        }
    }
    
    
    
    
    
    
}
