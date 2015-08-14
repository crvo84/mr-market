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
    let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    private var blockNode: SKShapeNode?
    private var itemNode: SKSpriteNode?
    private var textNode: SKLabelNode?
    
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
    
    init(itemTexture: SKTexture!, infoText: String, size: CGSize) {
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        // block
        blockNode = SKShapeNode(rectOfSize: size, cornerRadius: size.width * Geometry.BlockRelativeCornerRadius)
        blockNode!.fillColor = backgroundColor
        blockNode!.lineWidth = Geometry.BlockBorderWidth
        addChild(blockNode!)
        
        // item texture
        let side: CGFloat = size.height * Geometry.BlockItemRelativeHeight
        itemNode = SKSpriteNode(texture: itemTexture, color: SKColor.clearColor(), size: CGSize(width: side, height: side))
        itemNode!.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        let leftOffset: CGFloat = (size.height - side) / 2.0
        itemNode!.position = CGPoint(x: -size.width / 2 + leftOffset, y: 0) // relative to center of node
        blockNode!.addChild(itemNode!)
        
        // text node
        textNode = SKLabelNode(fontNamed: "Verdana")
        textNode!.text = infoText
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
