//
//  Block.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/12/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation
import SpriteKit

class Block: SKSpriteNode
{
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    let price: Price
    private var blockNode: SKShapeNode?
    private var itemNode: SKSpriteNode?
    private var textNode: SKLabelNode?
    
    private var currentReturn: Double {
        get {
            return price.company.currentPriceValue / price.value - 1.0
        }
    }
    
    var backgroundColor: SKColor = Color.BlockDefault {
        didSet {
            blockNode?.fillColor = backgroundColor
        }
    }
    
    var textColor: SKColor = Color.BlockTextDefault {
        didSet {
            textNode?.fontColor = textColor
        }
    }
    
    var isDescending: Bool = true {
        willSet {
            if isDescending && !newValue {
                backgroundColor = Color.BlockPurchased
            }
        }
    }
    
    init(price: Price, itemTexture: SKTexture!, size: CGSize) {
        self.price = price
        
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        // block
        blockNode = SKShapeNode(rectOfSize: size, cornerRadius: size.width * Geometry.BlockRelativeCornerRadius)
        blockNode!.fillColor = backgroundColor
        blockNode!.lineWidth = Geometry.BlockBorderWidth
        blockNode!.strokeColor = Color.BlockBorder
        addChild(blockNode!)
        
        // width and height left after border width
        let realBlockWidth = size.width - Geometry.BlockBorderWidth * 2
        let realBlockHeight = size.height - Geometry.BlockBorderWidth * 2
        
        // item texture
//        let side: CGFloat = size.height * Geometry.BlockItemRelativeHeight
        let itemSide: CGFloat = realBlockHeight * Geometry.BlockItemRelativeHeight
        itemNode = SKSpriteNode(texture: itemTexture, color: SKColor.clearColor(), size: CGSize(width: itemSide, height: itemSide))
        itemNode!.anchorPoint = CGPoint(x: 0.0, y: 0.5)
//        let itemNodeLeftOffset: CGFloat = (size.height - side) / 2.0
        let itemNodeLeftOffset: CGFloat = (realBlockHeight - itemSide) / 2.0
//        itemNode!.position = CGPoint(x: -size.width / 2 + itemNodeLeftOffset, y: 0) // relative to center of node
        itemNode!.position = CGPoint(x: -realBlockWidth / 2 + itemNodeLeftOffset, y: 0)
        blockNode!.addChild(itemNode!)
        

        // text node rect
        let blockSpaceLeftAfterItem = realBlockWidth - itemNode!.size.width - itemNodeLeftOffset
        let textRectHorizontalOffset = blockSpaceLeftAfterItem * (1 - Geometry.BlockTextRelativeWidth) / 2.0
        let textRectVerticalOffset = realBlockHeight * (1 - Geometry.BlockTextRelativeHeight) / 2.0
        let textRectX = itemNode!.position.x + itemNode!.frame.size.width + textRectHorizontalOffset
        let textRectY = realBlockHeight / 2.0 - textRectVerticalOffset
        let textRectWidth = blockSpaceLeftAfterItem * Geometry.BlockTextRelativeWidth
        let textRectHeight = realBlockHeight * Geometry.BlockTextRelativeHeight
        let textRect = CGRect(x: textRectX, y: textRectY, width: textRectWidth, height: textRectHeight)
        // text node
        textNode = SKLabelNode(fontNamed: FontName.BlockText)
        textNode!.fontColor = textColor
        textNode!.horizontalAlignmentMode = .Left
        textNode!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        textNode!.text = FontSize.BlockLargestPriceText // provisional largest text for font size adjustment
        textNode!.fontSize = FontSize.BlockPriceInitial // font size before adjustment
        adjustLabelFontSizeToFitRect(labelNode: textNode!, rect: textRect, centeredOnRect: false)
        textNode!.text = price.toString() // real text
        textNode!.position = CGPoint(x: textRectX, y: Geometry.BlockTextYOffset)
        blockNode!.addChild(textNode!)
        
        // create physics body
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.mass = Physics.BlockMass
        physicsBody?.linearDamping = Physics.BlockLinearDamping
        physicsBody?.restitution = Physics.BlockRestitution
        physicsBody?.categoryBitMask = Category.Block
        physicsBody?.contactTestBitMask = Category.Block | Category.Floor
        
        zPosition = ZPosition.Block
    }
    
    private func adjustLabelFontSizeToFitRect(labelNode labelNode:SKLabelNode, rect:CGRect, centeredOnRect: Bool) {

        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)

        // Change the fontSize.
        labelNode.fontSize *= scalingFactor

        // Optionally move the SKLabelNode to the center of the rectangle.
        if centeredOnRect {
            labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
        }
    }
    
    func updateColor() {
        var newColor = Color.BlockPurchased
        
        // Adjusted to max and min return to be represented with color
        var adjustedReturn = currentReturn
        if adjustedReturn < Color.BlockMaxLoss {
            adjustedReturn = Color.BlockMaxLoss
        } else if adjustedReturn > Color.BlockMaxProfit {
            adjustedReturn = Color.BlockMaxProfit
        }
        
        // Secondary color component value (e.g. if main component is green, this is the value for red and blue)
        let secondaryColorValueRange = Color.BlockMaxValueForSecondaryColor - Color.BlockMinValueForSecondaryColor
        
        // If return is higher, the secondaryColorValue should be lower so the color darker
        if adjustedReturn > 0.0 { // Profit
            let proportionOfRange = CGFloat(adjustedReturn / Color.BlockMaxProfit) * secondaryColorValueRange
            let secondaryColorValue = Color.BlockMaxValueForSecondaryColor - proportionOfRange
            newColor = SKColor(red: secondaryColorValue, green: 1.0, blue: secondaryColorValue, alpha: 1.0)
            
        } else if adjustedReturn < 0.0 {
            let proportionOfRange = CGFloat(adjustedReturn / Color.BlockMaxLoss)
            let secondaryColorValue = Color.BlockMaxValueForSecondaryColor - proportionOfRange
            newColor = SKColor(red: 1.0, green: secondaryColorValue, blue: secondaryColorValue, alpha: 1.0)
        }

        backgroundColor = newColor
    }
    
    func disappear()
    {
        let shrinkAction = SKAction.scaleTo(0.0, duration: Time.BlockShrink)
        let removeAction = SKAction.removeFromParent()
        runAction(SKAction.sequence([shrinkAction, removeAction]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
