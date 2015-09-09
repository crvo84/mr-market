//
//  TutorialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var mrMarketView: SKView!
    @IBOutlet weak var tutorialView: UIView!
    
    private var pageViewController: UIPageViewController?

    private var tutorialSentences: [String] = [Text.TutorialSentence0, Text.TutorialSentence1, Text.TutorialSentence2, Text.TutorialSentence3, Text.TutorialSentence4, Text.TutorialSentence5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mr market view setup
        // Create and configure scene
        var scene = MrMarketFaceScene(size: mrMarketView.bounds.size)
        scene.backgroundColor = Color.MainBackground
        scene.scaleMode = .AspectFill
        // Show the scene
        mrMarketView.presentScene(scene)
        
        tutorialView.backgroundColor = UIColor.clearColor()
        
        tutorialPageViewControllerSetup()

    }

    private func tutorialPageViewControllerSetup() {
        // Create page view controller
        pageViewController = storyboard!.instantiateViewControllerWithIdentifier(StoryboardId.TutorialPageViewController) as? UIPageViewController
        pageViewController!.dataSource = self
        
        let pageContentViewController = viewControllerAtIndex(0)
        let viewControllers = [pageContentViewController!]
        
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Change the size of page view controller
        pageViewController!.view.frame = tutorialView.bounds
        addChildViewController(pageViewController!)
        tutorialView.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }

        
    // MARK: UIPageViewController DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let tutorialPageContentViewController = viewController as? TutorialPageContentViewController {
            if let index = tutorialPageContentViewController.pageIndex {
                if index == tutorialSentences.count - 1 {
                    return self.viewControllerAtIndex(0)
                } else if index >= 0 && index < tutorialSentences.count - 1 {
                    return viewControllerAtIndex(index + 1)
                }
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let tutorialPageContentViewController = viewController as? TutorialPageContentViewController {
            if let index = tutorialPageContentViewController.pageIndex {
                if index > 0 && index <= tutorialSentences.count - 1 {
                    return viewControllerAtIndex(index - 1)
                }
            }
        }
        return nil
    }
    
    private func viewControllerAtIndex(index: Int) -> TutorialPageContentViewController? {
        if tutorialSentences.count > 0 && index < tutorialSentences.count {
            
            // create new tutorial page content view controller and pass suitable data
            if let tutorialPageContentViewController = storyboard!.instantiateViewControllerWithIdentifier(StoryboardId.TutorialPageContentViewController) as? TutorialPageContentViewController {
                tutorialPageContentViewController.labelText = tutorialSentences[index]
                tutorialPageContentViewController.pageIndex = index
                
                return tutorialPageContentViewController
            }
        }
        return nil
    }
    
    // Page indicator data source
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tutorialSentences.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    
    // MARK: Navigation
    @IBAction func unwindToTutorialViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

