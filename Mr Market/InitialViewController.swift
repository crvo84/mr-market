//
//  InitialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()        
    }

    private func updateUI()
    {
        // Music On/Off Button
        let musicOn = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.musicOn)
        let musicOnImage = UIImage(named: musicOn ? Filename.MusicOn : Filename.MusicOff)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        musicOnButton.setImage(UIImage(named: musicOn ? Filename.MusicOn : Filename.MusicOff), forState: UIControlState.Normal)
    }
    
    @IBOutlet weak var musicOnButton: UIButton!
    @IBAction func musicOnButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let musicOn = defaults.boolForKey(UserDefaultsKey.musicOn)
        defaults.setBool(!musicOn, forKey: UserDefaultsKey.musicOn)
        updateUI()
    }
}
