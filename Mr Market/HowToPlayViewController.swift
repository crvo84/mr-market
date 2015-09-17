//
//  HowToPlayViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import SpriteKit

class HowToPlayViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Configure de main view
        if let skView = view as? SKView {
            
            // Create and configure scene
            let scene = HowToPlayScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            scene.howToPlayViewController = self
            
            // Show the scene
            skView.presentScene(scene)
        }
    }

}
