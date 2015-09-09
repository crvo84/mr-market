//
//  TutorialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialViewController: UIViewController {
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    @IBOutlet weak var mrMarketView: SKView!
    
    @IBOutlet weak var tutorialSentenceLabel: UILabel!
    private var timer: NSTimer?
    
    private let sentences: [String] = [Text.TutorialSentence0, Text.TutorialSentence1, Text.TutorialSentence2, Text.TutorialSentence3, Text.TutorialSentence4, Text.TutorialSentence5, Text.TutorialSentence6]
    
    private var currentIndex: Int = 0 {
        didSet {
            if currentIndex >= sentences.count {
                currentIndex = 0
            } else if currentIndex < 0 {
                currentIndex = sentences.count - 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mr market view setup
        // Create and configure scene
        var scene = MrMarketFaceScene(size: mrMarketView.bounds.size)
        scene.backgroundColor = Color.MainBackground
        scene.scaleMode = .AspectFill
        // Show the scene
        mrMarketView.presentScene(scene)
        
        tutorialSentenceLabel.text = sentences[currentIndex]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(Time.TutorialSentenceBetweenLabels, target: self, selector: "updateTutorialSentenceNext", userInfo: nil, repeats: false)
    }
    
    func updateTutorialSentenceNext() {
        changeTutorialSentenceToIndex(++currentIndex)
    }
    
    private func updateTutorialSentencePrevious() {
        changeTutorialSentenceToIndex(--currentIndex)
    }
    
    // Label should have alpha = 0, every time this function is called
    private func changeTutorialSentenceToIndex(index: Int) {
        // reset timer
        timer?.invalidate()
        timer = nil
        
        // fade out current label
        UIView.animateWithDuration(Time.TutorialSentenceFadeInOut, animations: { () -> Void in
            
            self.tutorialSentenceLabel.alpha = 0.0
            
        }) { (_) -> Void in
            
            // change tutorial label text
            if self.currentIndex < self.sentences.count {
                self.tutorialSentenceLabel.text = self.sentences[self.currentIndex]
            }
            
            // fade in current label
            UIView.animateWithDuration(Time.TutorialSentenceFadeInOut, animations: { () -> Void in
                self.tutorialSentenceLabel.alpha = 1.0
            }, completion: { (_) -> Void in
                // set timer
                self.timer = NSTimer.scheduledTimerWithTimeInterval(Time.TutorialSentenceBetweenLabels, target: self, selector: "updateTutorialSentenceNext", userInfo: nil, repeats: false)
            })
        }
    }

    
    // MARK: Navigation
    @IBAction func unwindToTutorialViewController(segue: UIStoryboardSegue)
    {
        
    }
}

