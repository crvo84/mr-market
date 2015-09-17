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
    private var imageNode: SKSpriteNode?
    
    private struct Default {
        static let BackgroundColor = SKColor.clearColor()
        static let BorderWidth: CGFloat = 0.0
        static let BorderColor = SKColor.blackColor()
        static let LabelText = ""
        static let LabelFontName = "Arial"
        static let LabelFontColor = SKColor.blueColor()
        static let LabelFontSize: CGFloat = 20.0
        static let ImageRelativeWidth: CGFloat = 0.90
    }
    
    var backgroundColor = Default.BackgroundColor {
        didSet { backgroundNode?.fillColor = backgroundColor }
    }
    
    var highlighted: Bool = false {
        didSet {
            if highlighted {
                backgroundNode?.fillColor = backgroundColor.colorWithAlphaComponent(0.5)
            } else {
                backgroundNode?.fillColor = backgroundColor
            }
        }
    }
    
    var borderWidth: CGFloat = Default.BorderWidth {
        didSet { backgroundNode?.lineWidth = borderWidth }
    }
    
    var borderColor: SKColor = Default.BorderColor {
        didSet { backgroundNode?.strokeColor = borderColor }
    }
    
    var labelText: String? = "" {
        didSet {
            if labelText != nil {
                textLabelNode?.text = labelText!
            } else {
                textLabelNode?.text = Default.LabelText
            }
        }
    }
    
    var labelFontName: String = Default.LabelFontName {
        didSet { textLabelNode?.fontName = labelFontName }
    }
    
    var labelFontColor: SKColor = Default.LabelFontColor {
        didSet { textLabelNode?.fontColor = labelFontColor }
    }
    
    var labelFontSize: CGFloat = Default.LabelFontSize {
        didSet { textLabelNode?.fontSize = labelFontSize }
    }
    
    var imageTexture: SKTexture? {
        didSet { imageNode?.texture = imageTexture }
    }
    
    var imageRelativeWidth: CGFloat = Default.ImageRelativeWidth {
        didSet {
            let imageSide = backgroundNode!.frame.width * imageRelativeWidth
            imageNode?.size = CGSize(width: imageSide, height: imageSide)
        }
    }
    
    override var name: String? {
        didSet {
            super.name = name
            backgroundNode?.name = name
            textLabelNode?.name = name
            imageNode?.name = name
        }
    }
    
    init(size: CGSize, cornerRadius: CGFloat, labelText: String?, imageTexture: SKTexture?) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)

        // Background
        backgroundNode = SKShapeNode(rectOfSize: size, cornerRadius: cornerRadius)
        backgroundNode!.fillColor = backgroundColor
        backgroundNode!.lineWidth = borderWidth
        backgroundNode!.strokeColor = borderColor
        addChild(backgroundNode!)
        
        // Text Label
        textLabelNode = SKLabelNode()
        textLabelNode!.text = labelText != nil ? labelText! : Default.LabelText
        textLabelNode!.fontName = labelFontName
        textLabelNode!.fontSize = labelFontSize
        textLabelNode!.fontColor = labelFontColor
        textLabelNode!.verticalAlignmentMode = .Center
        textLabelNode!.horizontalAlignmentMode = .Center
        adjustLabelFontSize()
        backgroundNode!.addChild(textLabelNode!)
        
        // Sprite Node
        imageNode = SKSpriteNode()
        imageNode!.texture = imageTexture
        let imageSide = backgroundNode!.frame.size.width * Default.ImageRelativeWidth
        imageNode!.size = CGSize(width: imageSide, height: imageSide)
        backgroundNode!.addChild(imageNode!)
    }
    
    private func adjustLabelFontSize() {
        
        if backgroundNode == nil || textLabelNode == nil {
            return
        }
        
        let widthToFit = backgroundNode!.frame.size.width * Geometry.ButtonNodeLabelRelativeWidth
        let heightToFit = backgroundNode!.frame.size.height * Geometry.ButtonNodeLabelRelativeHeight

        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(widthToFit / textLabelNode!.frame.width, heightToFit / textLabelNode!.frame.height)
        
        // Change the fontSize.
        labelFontSize *= scalingFactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

