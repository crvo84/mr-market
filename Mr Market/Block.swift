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
        let textX = itemNode!.position.x + itemNode!.size.width + Geometry.BlockTextLeftOffset
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
        var newColor: SKColor
        if currentReturn > 0.1 {
            newColor = SKColor(red: 0.45, green: 1.0, blue: 0.45, alpha: 1.0)
        } else if currentReturn > 0.5 {
            newColor = SKColor(red: 0.60, green: 1.0, blue: 0.60, alpha: 1.0)
        } else if currentReturn > 0.0 {
            newColor = SKColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0)
        } else if currentReturn == 0.0 {
            newColor = Color.BlockPurchased
        } else if currentReturn > -0.05 {
            newColor = SKColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0)
        } else if currentReturn > -0.1 {
            newColor = SKColor(red: 1.0, green: 0.60, blue: 0.60, alpha: 1.0)
        } else {
            newColor = SKColor(red: 1.0, green: 0.45, blue: 0.45, alpha: 1.0)
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
