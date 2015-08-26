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
    var scene: MarketGameScene?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        // Configure de main view
        if let skView = view as? SKView {
            skView.showsFPS = true
            
            // Create and configure scene
            scene = MarketGameScene(size: view.bounds.size)
            scene!.scaleMode = .AspectFill
            scene!.marketGameViewController = self
            
            // Show the scene
            skView.presentScene(scene!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let segueId = segue.identifier {
            switch segueId {
            case SegueId.QuitGame:
                scene?.stopGameMusic()
            default:
                break
            }
        }
    }
    
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
    
    
    
    
}
