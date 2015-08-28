//
//  AboutViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/28/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import iAd

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        canDisplayBannerAds = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.ShowAds)
        
//        hiInvestButton.imageView?.layer.cornerRadius = hiInvestButton.frame.width * Geometry.HiInvestButtonRelativeCornerRadius
    }
    
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        if let websiteURL = NSURL(string: URLString.Villou) {
            UIApplication.sharedApplication().openURL(websiteURL)
        }
    }

    @IBAction func facebookButtonPressed(sender: UIButton) {
        if let facebookFromAppURL = NSURL(string: URLString.FacebookFromApp) {
            if UIApplication.sharedApplication().canOpenURL(facebookFromAppURL) {
                UIApplication.sharedApplication().openURL(facebookFromAppURL)
            } else {
                if let facebookURL = NSURL(string: URLString.Facebook) {
                    UIApplication.sharedApplication().openURL(facebookURL)
                }
            }
        }
    }

    @IBAction func twitterButtonPressed(sender: UIButton) {
        if let twitterFromAppURL = NSURL(string: URLString.TwitterFromApp) {
            if UIApplication.sharedApplication().canOpenURL(twitterFromAppURL) {
                UIApplication.sharedApplication().openURL(twitterFromAppURL)
            } else {
                if let twitterURL = NSURL(string: URLString.Twitter) {
                    UIApplication.sharedApplication().openURL(twitterURL)
                }
            }
        }
    }
    
//    @IBOutlet weak var hiInvestButton: UIButton!
//    
//    @IBAction func hiInvestButtonPressed(sender: UIButton) {
//    }
    
    
}

