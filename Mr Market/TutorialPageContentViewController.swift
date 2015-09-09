//
//  TutorialPageContentViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit

class TutorialPageContentViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var pageIndex: Int?
    var labelText: String? {
        didSet {
            if label != nil {
                label.text = labelText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = labelText
        
        label.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(Time.TutorialSentenceFadeInOut, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.label.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        label.alpha = 0.0
    }


}
