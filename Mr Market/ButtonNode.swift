//
//  ButtonNode.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/21/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode
{
    private var backgroundNode: SKShapeNode?
    private var textLabelNode: SKLabelNode?
    
    private struct Default {
        static let backgroundColor = SKColor.clearColor()
        static let borderWidth: CGFloat = 0.0
        static let borderColor = SKColor.blackColor()
        static let labelText = "Button"
        static let labelFontName = "Arial"
        static let labelFontColor = SKColor.blueColor()
        static let labelFontSize: CGFloat = 20.0
    }
    
    var backgroundColor = Default.backgroundColor {
        didSet { backgroundNode?.fillColor = backgroundColor }
    }
    
    var borderWidth: CGFloat = Default.borderWidth {
        didSet { backgroundNode?.lineWidth = borderWidth }
    }
    
    var borderColor: SKColor = Default.borderColor {
        didSet { backgroundNode?.strokeColor = borderColor }
    }
    
    var labelText: String = Default.labelText {
        didSet { textLabelNode?.text = labelText }
    }
    
    var labelFontName: String = Default.labelFontName {
        didSet { textLabelNode?.fontName = labelFontName }
    }
    
    var labelFontColor: SKColor = Default.labelFontColor {
        didSet { textLabelNode?.fontColor = labelFontColor }
    }
    
    var labelFontSize: CGFloat = Default.labelFontSize {
        didSet { textLabelNode?.fontSize = labelFontSize }
    }
    
    override var name: String? {
        didSet {
            super.name = name
            backgroundNode?.name = name
            textLabelNode?.name = name
        }
    }
    
    init(size: CGSize, cornerRadius: CGFloat, labelText: String?) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        
        // Background
        backgroundNode = SKShapeNode(rectOfSize: size, cornerRadius: cornerRadius)
        backgroundNode!.fillColor = backgroundColor
        backgroundNode!.lineWidth = borderWidth
        backgroundNode!.strokeColor = borderColor
        addChild(backgroundNode!)
        
        // Text Label
        textLabelNode = SKLabelNode()
        textLabelNode!.text = labelText != nil ? labelText! : self.labelText
        textLabelNode!.fontName = labelFontName
        textLabelNode!.fontSize = labelFontSize
        textLabelNode!.fontColor = labelFontColor
        textLabelNode!.verticalAlignmentMode = .Center
        textLabelNode!.horizontalAlignmentMode = .Center
        backgroundNode!.addChild(textLabelNode!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

