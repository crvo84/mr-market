//
//  MarketGameScene.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit
import AVFoundation

// Global but private (Works like a static variable in objective-c). To avoid a "wall of sound" or many copies of the same music
private var backgroundMusicPlayer: AVAudioPlayer!

class MarketGameScene: SKScene, SKPhysicsContactDelegate
{
    // Device
    let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    // Level label
    let levelLabelNode = SKLabelNode(fontNamed: FontName.LevelLabel)
    
    // Pause
    let pausedLabelNode = SKLabelNode(fontNamed: FontName.PausedLabel)
    let pauseButtonNode = SKSpriteNode(imageNamed: Filename.PauseButton)
    
    // Score
    let scoreLabelNode = SKLabelNode(fontNamed: FontName.ScoreLabel)
    
    // Audio
    private let popSoundAction = SKAction.playSoundFileNamed(Filename.PopSound, waitForCompletion: false)
    private let slamSoundAction = SKAction.playSoundFileNamed(Filename.SlamSound, waitForCompletion: false)

    // Texture
    private let textureAtlas = SKTextureAtlas(named: Filename.SpritesAtlas)
    
    // Market
    private var mrMarket: MrMarket?
    private var market: Market?
    private var companies: [Company]?
    private let portfolio = Portfolio()
    
    // Blocks
    private var existingBlocks: [Block] = []
    private var generateBlocksAction: SKAction?

    // Game variables (may increase on higher levels)
    var gameLevel: Int = 1
    private var numberOfCompanies: Int = GameOption.NumberOfCompanies
    private var numberOfPeriods: Int = GameOption.Periods
    private var gameSpeed: CGFloat = GameOption.Speed
    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true
        backgroundColor = Color.MainBackground
        gameLevelVariablesSetup()
        pauseGameSetup()
        scoreLabelSetup()
        physicsWorldSetup()
        marketSetup()
        audioSetup()
        levelLabelSetup()
        
        let onScreenLevelLabelAction = SKAction.waitForDuration(Time.LevelLabelOnScreen)
        let fadeOutLevelLabelAction = SKAction.fadeOutWithDuration(Time.LevelLabelFadeOut)
        let removeLevelLabelAction = SKAction.removeFromParent()
        levelLabelNode.runAction(SKAction.sequence([onScreenLevelLabelAction, fadeOutLevelLabelAction, removeLevelLabelAction]))
        let startGameAction = SKAction.runBlock { self.generateBlocks() }
        self.runAction(SKAction.sequence([SKAction.waitForDuration(Time.LevelLabelOnScreen), startGameAction]))
    }
    
    private func gameLevelVariablesSetup() {
        numberOfCompanies = GameOption.NumberOfCompanies + GameOption.NumberOfCompaniesIncrease * (gameLevel - 1)
        if numberOfCompanies > Texture.numberOfBlockImages { numberOfCompanies = Texture.numberOfBlockImages }
        
        numberOfPeriods = GameOption.Periods + GameOption.PeriodsIncrease * (gameLevel - 1)
        if numberOfPeriods > GameOption.MaxPeriods { numberOfPeriods = GameOption.MaxPeriods }
        
        gameSpeed = GameOption.Speed + GameOption.SpeedIncrease * CGFloat(gameLevel - 1)
    }
    
    private func levelLabelSetup()
    {
        levelLabelNode.text = "Level \(gameLevel)"
        levelLabelNode.fontColor = Color.LevelLabel
        levelLabelNode.fontSize = isIpad ? FontSize.LevelLabelIpad : FontSize.LevelLabelIphone
        levelLabelNode.verticalAlignmentMode = .Center
        levelLabelNode.horizontalAlignmentMode = .Center
        levelLabelNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        levelLabelNode.zPosition = ZPosition.LevelLabel
        addChild(levelLabelNode)
    }
    
    private func pauseGameSetup()
    {
        // paused label
        pausedLabelNode.text = "Paused"
        pausedLabelNode.fontColor = Color.PausedLabel
        pausedLabelNode.fontSize = isIpad ? FontSize.PausedLabelIpad : FontSize.PausedLabelIphone
        pausedLabelNode.verticalAlignmentMode = .Center
        pausedLabelNode.horizontalAlignmentMode = .Center
        pausedLabelNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        pausedLabelNode.zPosition = ZPosition.PausedLabel
        pausedLabelNode.hidden = true
        addChild(pausedLabelNode)
        
        // pause button
        pauseButtonNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        pauseButtonNode.position = CGPoint(x: size.width - Geometry.PauseButtonRightOffset, y: size.height - Geometry.PauseButtonUpperOffset)
        pauseButtonNode.name = NodeName.PauseButton
        pauseButtonNode.zPosition = ZPosition.PauseButton
        addChild(pauseButtonNode)
    }
    
    private func scoreLabelSetup()
    {
        scoreLabelNode.text = portfolio.cashToString()
        scoreLabelNode.fontColor = Color.ScoreLabel
        scoreLabelNode.fontSize = isIpad ? FontSize.ScoreLabelIpad : FontSize.ScoreLabelIphone
        scoreLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabelNode.position = CGPoint(x: size.width / 2.0 , y: size.height - Geometry.ScoreLabelUpperOffset)
        scoreLabelNode.zPosition = ZPosition.ScoreLabel
        addChild(scoreLabelNode)
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
    
    private func marketSetup()
    {
        let initialMarketLevel = GameOption.InitialMarketLevel + (gameLevel - 1) * GameOption.InitialMarketLevelIncrease
        market = Market(initialLevel: 0)
        companies = Company.generateCompanies(numberOfCompanies)
        
        // add mr market
        let mrMarketWidth: CGFloat = size.width * Geometry.MrMarketRelativeWidth
        let mrMarketHeight: CGFloat = mrMarketWidth / Geometry.MrMarketAspectRatio
        mrMarket = MrMarket(textureAtlas: textureAtlas, size: CGSizeMake(mrMarketWidth, mrMarketHeight), level: market!.level)
        mrMarket?.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mrMarket!.position = CGPoint(x: Geometry.MrMarketLeftOffset, y: size.height - Geometry.MrMarketTopOffset)
        mrMarket!.name = NodeName.MrMarket
        addChild(mrMarket!)
    }
    
    
    private func generateBlocks()
    {
        // block size
        let blockWidth = (size.width - Geometry.BlockHorizontalSeparation * (Geometry.BlocksPerLine + 1)) / Geometry.BlocksPerLine
        //        let blockHeight = blockWidth * Geometry.BlockRelativeHeight
        let blockHeight = size.height / Geometry.BlocksPerColumn
        let blockSize = CGSize(width: blockWidth, height: blockHeight)
        

        var onePeriodActions: [SKAction] = []
        for i in 0..<numberOfPeriods {
            
            var oneBlockActions: [SKAction] = []
            for j in 0..<self.companies!.count {
                let oneBlockAction = SKAction.runBlock { [unowned self] in
                    
                    let company = self.companies![j]
                    let itemTexture = SKTexture(imageNamed: Texture.blockImageNamePrefix + "\(j)")
                    let price = company.newPriceWithMarketReturn(self.market!.lastReturn)
                    
                    let newBlock = Block(price: price, itemTexture: itemTexture, size: blockSize)
                    //random position
                    let randomBlockPosition = CGFloat(arc4random_uniform(UInt32(Geometry.BlocksPerLine))) // Random number between 0 and n-1
                    let blockX = (Geometry.BlockHorizontalSeparation + blockWidth / 2.0) + randomBlockPosition * (blockWidth + Geometry.BlockHorizontalSeparation)
                    let blockY = self.size.height + blockHeight / 2.0
                    newBlock.position = CGPoint(x: blockX, y: blockY)
                    self.existingBlocks.append(newBlock)
                    self.addChild(newBlock)
                    self.updateBlockColors()
                }
                
                let waitAction = SKAction.waitForDuration(Time.BetweenBlocks)
                
                let oneBlockAndWaitAction = SKAction.sequence([oneBlockAction, waitAction])
                oneBlockActions.append(oneBlockAndWaitAction)
            }
            
            let onePeriodAction = SKAction.sequence(oneBlockActions)
            let updateMrMarketAction = SKAction.runBlock{ self.mrMarket!.level = self.market!.newMarketLevel() }
            let onePeriodAndWaitAction = SKAction.sequence([onePeriodAction, SKAction.waitForDuration(Time.BetweenPeriods), updateMrMarketAction])
            onePeriodActions.append(onePeriodAndWaitAction)
        }
        
        onePeriodActions.append(SKAction.runBlock{ self.finishedGame() })
        
        generateBlocksAction = SKAction.sequence(onePeriodActions)
        runAction(generateBlocksAction)
    }
    
    private func updateBlockColors() {
        for block in existingBlocks {
            if !block.isDescending {
                block.updateColor()
            }
        }
    }
    
    private func audioSetup()
    {
        // setup background music
        if backgroundMusicPlayer == nil {
            if let backgroundMusicURL = NSBundle.mainBundle().URLForResource(Filename.BackgroundMusic, withExtension: nil) {
                backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: nil)
                backgroundMusicPlayer.numberOfLoops = -1
                backgroundMusicPlayer.enableRate = true
            }
        }
        let newMusicRateTEST = 1.0 + Float(gameLevel - 1) * GameOption.MusicRateIncrease
        backgroundMusicPlayer.rate = 1.0 + Float(gameLevel - 1) * GameOption.MusicRateIncrease
        let musicOn = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.musicOn)
        if !backgroundMusicPlayer.playing && musicOn {
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
    
    func explosion(position: CGPoint)
    {
        var emitterNode = SKEmitterNode(fileNamed: Filename.SparkEmitter)

        emitterNode.position = position
        
        let explodeAction = SKAction.runBlock { self.addChild(emitterNode) }
        let waitAction = SKAction.waitForDuration(Time.BlockExplosion)
        let disappearAction = SKAction.runBlock { emitterNode.removeFromParent() }
        
        runAction(SKAction.sequence([explodeAction, waitAction, disappearAction]))
    }

    private func deleteBlock(block: Block) {
        if let index = find(existingBlocks, block) {
            portfolio.sellPrice(block.price)
            scoreLabelNode.text = portfolio.cashToString()
            existingBlocks.removeAtIndex(index)
            block.disappear()
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        if let name = self.nodeAtPoint(location).name {
            switch name {
            case NodeName.PauseButton:
                pauseButtonPressed()
            default:
                break
            }
        } else if !view!.paused {
            if let body = physicsWorld.bodyAtPoint(location) {
                if let blockNode = body.node as? Block {
                    if blockNode.isDescending {
                        runAction(popSoundAction)
                        explosion(blockNode.position)
                        deleteBlock(blockNode)
                    } else {
                        deleteBlock(blockNode)
                        // add cash sound
                    }
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        updateBlockColors()
        
        if let blockA = nodeA as? Block {
            if let blockB = nodeB as? Block {
                // blockA collided with blockB
                if !blockA.isDescending || !blockB.isDescending {
                    if blockA.isDescending { portfolio.buyPrice(blockA.price) }
                    if blockB.isDescending { portfolio.buyPrice(blockB.price) }
                    runAction(slamSoundAction)
                    blockA.isDescending = false
                    blockB.isDescending = false
                    if blockA.position.y + blockA.size.height / 2.0 > size.height || blockB.position.y + blockB.size.height / 2.0 > size.height {
                        gameOver()
                    }
                }
            } else {
                // blockA collided with floor
                portfolio.buyPrice(blockA.price)
                runAction(slamSoundAction)
                blockA.isDescending = false
            }
        } else {
            // blockB collided with floor
            if let blockB = nodeB as? Block {
                portfolio.buyPrice(blockB.price)
                runAction(slamSoundAction)
                blockB.isDescending = false
            }
        }
    }
    
    private func transitionToNextLevel()
    {
        let nextLevelTransition = SKTransition.crossFadeWithDuration(1.0)
        let nextLevelScene = MarketGameScene(size: size)
        nextLevelScene.gameLevel = gameLevel + 1
        nextLevelScene.portfolio.cash = portfolio.cash
        view?.presentScene(nextLevelScene, transition: nextLevelTransition)
    }
    
    private func finishedGame()
    {
        for var i = existingBlocks.count - 1; i >= 0; i-- {
            let block = existingBlocks[i]
            deleteBlock(block)
        }
        // Transition to next level
        transitionToNextLevel()
    }
    
    private func gameOver()
    {
        removeAllActions()
        shakeNode(mrMarket!)
        // TODO: game over sound here
        explodeAllBlocks()
        // Present game over node or scene
    }
    
    private func explodeAllBlocks() {
        for var i = existingBlocks.count - 1; i >= 0; i-- {
            let block = existingBlocks[i]
            explosion(block.position)
            deleteBlock(block)
        }
    }
    
    private func pauseButtonPressed()
    {
        // Pause action
        // Show Pause node
        
    }
    
    
    
}
