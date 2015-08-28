//
//  MarketGameViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit
import GameKit
import iAd

class MarketGameViewController: UIViewController, ADBannerViewDelegate
{
    // iAd Banner
    var adBanner: ADBannerView?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ad banner setup
        if NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.ShowAds) {
            adBanner = ADBannerView(frame: CGRectZero)
            adBanner!.delegate = self
            adBanner!.frame = CGRectMake(0.0, view.frame.size.height - adBanner!.frame.size.height, adBanner!.frame.size.width, adBanner!.frame.size.height)
            adBanner!.backgroundColor = Color.AdBannerBackground
            view.addSubview(adBanner!)
            
            // TODO: Add "Mr Market" label to show if ad is not available
        }

        // Configure de main view
        if let skView = view as? SKView {
            skView.showsFPS = true
            
            // Create and configure scene
            var scene = MarketGameScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            scene.marketGameViewController = self
            
            if adBanner != nil {
                scene.adBottomOffset = adBanner!.frame.height
            }
            
            // Show the scene
            skView.presentScene(scene)
        }

    }
    
    // MARK: UIActivity View Controller
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: Game Center
    
    func reportScoreForCash(cash: Double) {
        let score = GKScore(leaderboardIdentifier: GameCenter.LeaderboardId)

        score.value = Int64(cash * 100.0)
        
        GKScore.reportScores([score], withCompletionHandler: { (error) -> Void in
            if error != nil {
                println("Failed to report score: \(error)")
            } else {
                println("Successfully logged score!")
            }
        })
    }

    // MARK: iAd
    /* Ad Banner View Delegate */
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        /* whatever you need */
        if let skView = view as? SKView {
            if let gameScene = skView.scene as? MarketGameScene {
                gameScene.pauseGame()
            }
        }
        
        return true
    }
    
//    func bannerViewActionDidFinish(banner: ADBannerView!) {
//        /* whatever you need */
//    }
    
//    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        banner.hidden = false
//    }
    
//    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//        /* whatever you need */
//        banner.hidden = true
//    }
    
//    func bannerViewWillLoadAd(banner: ADBannerView!) {
//        /* whatever you need */
//    }
    
    
    
    
}
