//
//  MarketGameScene.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class MarketGameScene: SKScene, SKPhysicsContactDelegate
{
    let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    private let textureAtlas = SKTextureAtlas(named: Filename.SpritesAtlas)
    private var mrMarketNode: MrMarket?
    private var timer: NSTimer?
    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true
        
        backgroundColor = Color.MainBackground
        
        // set up physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: Physics.Gravity)
        // create floor physics body
        physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0.0, y: 0.0), toPoint: CGPoint(x: size.width, y: 0.0))
        
        // add mr market
        let mrMarketWidth: CGFloat = size.width * Geometry.MrMarketRelativeWidth
        let mrMarketHeight: CGFloat = mrMarketWidth / Geometry.MrMarketAspectRatio
        mrMarketNode = MrMarket(textureAtlas: textureAtlas, size: CGSizeMake(mrMarketWidth, mrMarketHeight), level: 0.0)
        mrMarketNode?.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mrMarketNode!.position = CGPoint(x: Geometry.MrMarketLeftOffset, y: size.height - Geometry.MrMarketTopOffset)
        mrMarketNode!.name = "mrMarket"
        addChild(mrMarketNode!)
        
        
        // creating blocks
        // block size
        let blockWidth = (self.size.width - Geometry.BlockHorizontalSeparation * (Geometry.BlocksPerLine + 1)) / Geometry.BlocksPerLine
        let blockHeight = blockWidth * Geometry.BlockRelativeHeight
        let blockSize = CGSize(width: blockWidth, height: blockHeight)
        let addNewBlock = SKAction.runBlock {
            if self.noMoreSpaceForBlocks(blockSize) {
                return // TODO: implement game over
            }
            
            // select item texture
            let randomItemIndex = arc4random_uniform(Texture.numberOfBlockItems) // Random number between 0 and n-1
            let itemTexture = SKTexture(imageNamed: Texture.blockItemNamePrefix + "\(randomItemIndex)")
            // create block
            let randomPrice = Double(arc4random_uniform(Price.MaxInitialInteger)) + Double(arc4random_uniform(10)) / 10.0
            let priceStr = String(format: "$%.1f", randomPrice)
            let block = Block(itemTexture: itemTexture, infoText: priceStr, size: blockSize)
            // random position
            let randomBlockPosition = CGFloat(arc4random_uniform(UInt32(Geometry.BlocksPerLine))) // Random number between 0 and n-1
            let blockX = (Geometry.BlockHorizontalSeparation + blockWidth / 2.0) + randomBlockPosition * (blockWidth + Geometry.BlockHorizontalSeparation)
            let blockY = self.size.height + blockHeight / 2.0
            block.position = CGPoint(x: blockX, y: blockY)
            self.addChild(block)
            
            self.mrMarketNode?.level++
        }
        let waitAction = SKAction.waitForDuration(Time.BetweenBlocks)

        runAction(SKAction.repeatActionForever(SKAction.sequence([addNewBlock, waitAction])))
    }
    
    private func noMoreSpaceForBlocks(blockSize: CGSize) -> Bool {
        var x = Geometry.BlockHorizontalSeparation + blockSize.width / 2.0
        var y = mrMarketNode!.position.y - mrMarketNode!.size.height - blockSize.height / 2 // just below mrMarketNode
        for i in 0..<Int(Geometry.BlocksPerLine) {
            let location1 = CGPoint(x: x, y: y)
            if let body = physicsWorld.bodyAtPoint(location1) {
                if let blockNode = body.node as? Block {
                    // Check if block node is descending or already purchased
                    return true
                }
            }
            x += CGFloat(i) * (Geometry.BlockHorizontalSeparation + blockSize.width)
        }
        
        return false
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(location) {
            if let blockNode = body.node as? Block {
                if blockNode.isDescending {
                    explosion(blockNode.position)
                    blockNode.disappear()
                    // add explosion sound
                } else {
                    blockNode.disappear()
                    // add cash sound
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if let blockA = nodeA as? Block {
            if let blockB = nodeB as? Block {
                // blockA collided with blockB
                if !blockA.isDescending || !blockB.isDescending {
                    blockA.isDescending = false
                    blockB.isDescending = false
                }
            } else {
                // blockA collided with floor
                blockA.isDescending = false
            }
        } else {
            // blockB collided with floor
            if let blockB = nodeB as? Block {
                blockB.isDescending = false
            }
        }
    }
    
    func explosion(position: CGPoint)
    {
        var emitterNode = SKEmitterNode(fileNamed: Filename.SparkEmitter)
        emitterNode.position = position
        
        let explodeAction = SKAction.runBlock { self.addChild(emitterNode) }
        let waitAction = SKAction.waitForDuration(Time.BlockExplosion)
        let disappearAction = SKAction.runBlock { emitterNode.removeFromParent() }
        
        runAction(SKAction.sequence([explodeAction, waitAction, disappearAction]))
        
    }
    
    
    
    
}
