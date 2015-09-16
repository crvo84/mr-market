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
        
        // item texture
        let side: CGFloat = size.height * Geometry.BlockItemRelativeHeight
        itemNode = SKSpriteNode(texture: itemTexture, color: SKColor.clearColor(), size: CGSize(width: side, height: side))
        itemNode!.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        let leftOffset: CGFloat = (size.height - side) / 2.0
        itemNode!.position = CGPoint(x: -size.width / 2 + leftOffset, y: 0) // relative to center of node
        blockNode!.addChild(itemNode!)
        
        // text node
        textNode = SKLabelNode(fontNamed: FontName.BlockText)
        textNode!.text = price.toString()
        textNode!.fontColor = textColor
        textNode!.fontSize = isIpad ? FontSize.BlockTextIpad : FontSize.BlockTextIphone
        textNode!.horizontalAlignmentMode = .Left
        textNode!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        let textX = itemNode!.position.x + itemNode!.size.width + (isIpad ? Geometry.BlockTextLeftOffsetIpad : Geometry.BlockTextLeftOffsetIphone)
        let textY = Geometry.BlockTextVerticalOffset // origin Y is 0
        textNode!.position = CGPoint(x: textX, y: textY)
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
        //        physicsBody?.collisionBitMask = 0
        
        zPosition = ZPosition.Block
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
