//
//  GameLabelNode.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/16/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import SpriteKit

class GameLabelNode: SKSpriteNode {
    
    private var backgroundNode: SKShapeNode?
    
    private var labelNode: SKLabelNode?
    
    var textRelativeWidth: CGFloat = 0.80 {
        didSet {
            adjustLabelFontSize()
        }
    }
    
    var textRelativeHeight: CGFloat = 0.5 {
        didSet {
            adjustLabelFontSize()
        }
    }
    
    var text: String? {
        didSet {
            if let validText = text {
                labelNode?.text = validText
            } else {
                labelNode?.text = ""
            }
            adjustLabelFontSize()
        }
    }
    
    var fontColor: SKColor = SKColor.blackColor() {
        didSet {
            labelNode?.fontColor = fontColor
        }
    }
    
    var fontName: String = "Arial" {
        didSet {
            labelNode?.fontName = fontName
        }
    }
    
    var backgroundColor: SKColor = SKColor.clearColor() {
        didSet {
            backgroundNode?.fillColor = backgroundColor
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            backgroundNode?.lineWidth = borderWidth
        }
    }
    
    var borderColor: SKColor = SKColor.clearColor() {
        didSet {
            backgroundNode?.strokeColor = borderColor
        }
    }
    
    
    init(size: CGSize, cornerRadius: CGFloat, text: String?)
    {
        self.text = text
        
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        // background node
        backgroundNode = SKShapeNode(rectOfSize: size, cornerRadius: cornerRadius)
        backgroundNode!.fillColor = backgroundColor
        backgroundNode!.strokeColor = borderColor
        backgroundNode!.lineWidth = borderWidth
        addChild(backgroundNode!)
        
        // label node
        let initialText = text == nil ? "" : text!
        labelNode = SKLabelNode(text: initialText)
        labelNode!.fontName = fontName
        labelNode!.fontColor = fontColor
        labelNode!.verticalAlignmentMode = .Center
        labelNode!.horizontalAlignmentMode = .Center
        adjustLabelFontSize()
        backgroundNode!.addChild(labelNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // label font size adjustment
    func adjustLabelFontSize() {
        
        if labelNode != nil && backgroundNode != nil {
        
            let widthToFit = backgroundNode!.frame.size.width * textRelativeWidth
            let heightToFit = backgroundNode!.frame.size.height * textRelativeHeight
            
            var scalingFactor: CGFloat = 1.0
            
            if labelNode!.frame.width > 0 && labelNode!.frame.height > 0 {
                // Determine the font scaling factor that should let the label text fit in the given rectangle.
                scalingFactor = min(widthToFit / labelNode!.frame.width, heightToFit / labelNode!.frame.height)
            }
            
            // Change the fontSize.
            labelNode!.fontSize *= scalingFactor
            
            labelNode!.position = CGPoint(x: 0.0, y: 0.0)
        }
    }
   
}
