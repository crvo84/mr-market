//
//  MarketGameScene.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit
import AVFoundation

class MarketGameScene: SKScene, SKPhysicsContactDelegate
{
    // Device
    let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    // Audio
    private var backgroundMusicPlayer: AVAudioPlayer!
    private let popSoundAction = SKAction.playSoundFileNamed(Filename.PopSound, waitForCompletion: false)
    private let slamSoundAction = SKAction.playSoundFileNamed(Filename.SlamSound, waitForCompletion: false)

    // Texture
    private let textureAtlas = SKTextureAtlas(named: Filename.SpritesAtlas)
    
    // Mr Market
    private var mrMarketNode: MrMarket?
    
    // Blocks
    private var generateBlocksAction: SKAction?

    // Game variables
    var numberOfCompanies = GameOptions.NumberOfCompanies
    var numberOfPeriods = GameOptions.Periods
    var marketVolatility = GameOptions.MarketVolatility
    var gameSpeed = GameOptions.Speed
//    var market: Market = Market(
    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true
        backgroundColor = Color.MainBackground

        physicsWorldSetup()
        createMrMarket()
        generateBlocks()
//        audioSetup()
    }
    
    private func physicsWorldSetup()
    {
        // set up physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: Physics.Gravity)
        physicsWorld.speed = self.gameSpeed
        // create floor physics body
        physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0.0, y: 0.0), toPoint: CGPoint(x: size.width, y: 0.0))
        physicsBody?.restitution = Physics.BlockRestitution
    }
    
    private func createMrMarket()
    {
        // add mr market
        let mrMarketWidth: CGFloat = size.width * Geometry.MrMarketRelativeWidth
        let mrMarketHeight: CGFloat = mrMarketWidth / Geometry.MrMarketAspectRatio
        mrMarketNode = MrMarket(textureAtlas: textureAtlas, size: CGSizeMake(mrMarketWidth, mrMarketHeight), level: 0.0)
        mrMarketNode?.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mrMarketNode!.position = CGPoint(x: Geometry.MrMarketLeftOffset, y: size.height - Geometry.MrMarketTopOffset)
        mrMarketNode!.name = "mrMarket"
        addChild(mrMarketNode!)
    }
    
    private func generateBlocks()
    {
        // creating blocks
        // block size
        let blockWidth = (size.width - Geometry.BlockHorizontalSeparation * (Geometry.BlocksPerLine + 1)) / Geometry.BlocksPerLine
        //        let blockHeight = blockWidth * Geometry.BlockRelativeHeight
        let blockHeight = size.height / Geometry.BlocksPerColumn
        let blockSize = CGSize(width: blockWidth, height: blockHeight)
        let addNewBlock = SKAction.runBlock { 
            
            // select item texture
            let randomItemIndex = arc4random_uniform(UInt32(Texture.numberOfBlockImages)) // Random number between 0 and n-1
            let itemTexture = SKTexture(imageNamed: Texture.blockImageNamePrefix + "\(randomItemIndex)")
            
            // create block
            let randomLimit: UInt32 = CompanyInfo.MaxInitialPriceInteger - CompanyInfo.MinInitialPriceInteger + 1
            let priceInteger = Double(arc4random_uniform(randomLimit) + CompanyInfo.MinInitialPriceInteger)
            let randomPrice = priceInteger + Double(arc4random_uniform(10)) / 10.0
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
        generateBlocksAction = SKAction.repeatActionForever(SKAction.sequence([addNewBlock, waitAction]))
        runAction(generateBlocksAction)
    }
    
    private func audioSetup()
    {
        // setup background music
        if backgroundMusicPlayer == nil {
            if let backgroundMusicURL = NSBundle.mainBundle().URLForResource(Filename.BackgroundMusic, withExtension: nil) {
                backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: nil)
                backgroundMusicPlayer.numberOfLoops = -1
            }
        }
        if !backgroundMusicPlayer.playing {
            backgroundMusicPlayer.play()
        }
    }
    
    private func shakeNode(node: SKNode)
    {
        // Cancel any existing shake actions
        node.removeActionForKey(Shake.Key)
        // The number of individual movements that the shake will be made up of
        let shakeSteps = Shake.Movements
        // How "big" the shake is
        let shakeDistance = Shake.Distance
        // How long the shake should go on for
        let shakeDuration = Shake.Duration
        // An array to store the individual movements in
        var shakeActions: [SKAction] = []
        
        // loop 'shakeSteps' times
        for i in 0...shakeSteps {
            // How long a specific shake movement will take
            let shakeMovementDuration: Double = shakeDuration / Double(shakeSteps)
            // This will be 1.0 at the start and gradually move down to 0.0
            let shakeAmount: Double = Double(shakeSteps - i) / Double(shakeSteps)
            // Take the current position, we'll then add an offset from that
            var shakePosition = node.position
            // Pick a random amount from -shakeDistance to shakeDistance
            let xPos = (Double(arc4random_uniform(UInt32(shakeDistance*2))) - Double(shakeDistance)) * shakeAmount
            let yPos = (Double(arc4random_uniform(UInt32(shakeDistance*2))) - Double(shakeDistance)) * shakeAmount
            shakePosition.x = shakePosition.x + CGFloat(xPos)
            shakePosition.y = shakePosition.y + CGFloat(yPos)
            
            // Create the action that moves the node to the new location, and add it to the list
            let shakeMovementAction = SKAction.moveTo(shakePosition, duration: shakeMovementDuration)
            shakeActions.append(shakeMovementAction)
        }
        
        // Run the shake
        let shakeSequence = SKAction.sequence(shakeActions)
        node.runAction(shakeSequence, withKey: Shake.Key)
    }
    
    private func gameOver()
    {
        removeAllActions()
        shakeNode(mrMarketNode!)
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


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(location) {
            if let blockNode = body.node as? Block {
                if blockNode.isDescending {
//                    runAction(popSoundAction)
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
//                    runAction(slamSoundAction)
                    blockA.isDescending = false
                    blockB.isDescending = false
                    if blockA.position.y + blockA.size.height / 2.0 > size.height || blockB.position.y + blockB.size.height / 2.0 > size.height {
                        gameOver()
                    }
                }
            } else {
                // blockA collided with floor
//                runAction(slamSoundAction)
                blockA.isDescending = false
            }
        } else {
            // blockB collided with floor
            if let blockB = nodeB as? Block {
//                runAction(slamSoundAction)
                blockB.isDescending = false
            }
        }
    }
    

    
    
    
}
