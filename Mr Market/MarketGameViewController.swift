//
//  MarketGameViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class MarketGameViewController: UIViewController
{
    var scene: MarketGameScene!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        // Configure de main view
        if let skView = view as? SKView {
            skView.showsFPS = true
            
            // Create and configure scene
            scene = MarketGameScene(size: view.bounds.size)
            scene.scaleMode = .AspectFill
            
            // Show the scene
            skView.presentScene(scene)
        }
    }
}
