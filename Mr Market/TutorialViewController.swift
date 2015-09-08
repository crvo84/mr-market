//
//  TutorialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class TutorialViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure de main view
        if let skView = view as? SKView {
            skView.showsFPS = true // TODO: remove showFPS
            
            // Create and configure scene
            var scene = GameTutorialScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            scene.tutorialViewController = self

            // Show the scene
            skView.presentScene(scene)
        }
        
    }
}
