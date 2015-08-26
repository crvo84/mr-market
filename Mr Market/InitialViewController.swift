//
//  InitialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit
import StoreKit

// Global but private (Works like a static variable in objective-c). To avoid a "wall of sound" or many copies of the same music
private var backgroundMusicPlayer: AVAudioPlayer!

class InitialViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var isGameCenterEnabled = false
    
    var product: SKProduct?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticatePlayer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        audioSetup()
        updateUI()
    }
    
    // MARK: Setup
    
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
    
    
    // MARK: Navigation
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue)
    {
        if let segueName = segue.identifier {
            switch segueName {
            case SegueId.RemoveAds:
                // Remove ads
                println("Remove Ads Button pressed")
            default:
                break
            }
        }
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
    
    // MARK: Game Center
    
    func authenticatePlayer()
    {
        if let localPlayer = GKLocalPlayer.localPlayer() {
            // Assigning a block to the localPlayer's
            // authenticateHandler kicks off the process
            // of authenticating the user with Game Center.
            localPlayer.authenticateHandler = { (viewController, error) in
                
                if viewController != nil {
                    // We need to present a view controller
                    // to finish the authentication process
                    self.presentViewController(viewController, animated: true, completion: nil)
                    
                } else if localPlayer.authenticated {
                    // We're authenticated, and can now use Game Center features
                    println("Authenticated")
                    self.isGameCenterEnabled = true
                    
                } else if let theError = error {
                    // We're not authenticated.
                    println("Error! \(theError)")
                    self.isGameCenterEnabled = false
                }
                
            }
        }
    }
    
    @IBAction func leaderboardButtonPressed(sender: AnyObject)
    {
        var gameCenterViewController: GKGameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterViewController.leaderboardIdentifier = GameCenter.LeaderboardId
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: In-App Purchases
    
    @IBAction func removeAdsButtonPressed(sender: AnyObject) {
        removeAds()
    }
    
    private func removeAds()
    {
        
    }

    
}
