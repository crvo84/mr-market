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
    // View Controller
    weak var marketGameViewController: MarketGameViewController?
    
    // bottom offset (Must be set before scene is presented)
    var adBottomOffset: CGFloat = 0.0
    
    // MrMarketGame
    private let game = MrMarketGame()
    
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    // Pause
    private var isGamePaused = false
    private var isGameOver = false
    private let pauseButtonNode = SKSpriteNode(imageNamed: Filename.PauseButton)
    private var pauseNode: PauseNode?
    
    // Game Over
    private var gameOverNode: GameOverNode?
    
    // Score
    private let scoreLabelNode = SKLabelNode(fontNamed: FontName.ScoreLabel)
    
    // Audio
    private let popSoundAction = SKAction.playSoundFileNamed(Filename.PopSound, waitForCompletion: false)
    private let slamSoundAction = SKAction.playSoundFileNamed(Filename.SlamSound, waitForCompletion: false)
    private var isMusicOn: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.MusicOn) }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserDefaultsKey.MusicOn) }
    }
    
    // Speed
    private var gameSpeed: CGFloat {
        get {
            return GameOption.SpeedInitial + GameOption.SpeedIncrease * CGFloat(game.gameLevel - 1)
        }
    }
    
    private var timeBetweenBlocks: Double {
        return Time.BetweenBlocksForInitialSpeed / Double(gameSpeed)
    }
    
    private var timeBetweenPeriods: Double {
        return Time.BetweenPeriodsForInitialSpeed / Double(gameSpeed)
    }
    

    // Texture
    private let textureAtlas = SKTextureAtlas(named: Filename.SpritesAtlas)
    
    // Market
    private var mrMarket: MrMarket?

    // Blocks
    private var existingBlocks: [Block] = []
    private var blockSize: CGSize {
        // block size
        let blockWidth = (size.width - Geometry.BlockHorizontalSeparation * (Geometry.BlocksPerLine + 1)) / Geometry.BlocksPerLine
        return CGSize(width: blockWidth, height: size.height / Geometry.BlocksPerColumn)
    }
    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true
        backgroundColor = Color.MainBackground
        registerAppTransitionObservers()
        pauseGameSetup()
        scoreLabelSetup()
        physicsWorldSetup()
        mrMarketSetup()
        audioSetup()

        performOneLevelActions()
    }
    
    
    private func performOneLevelActions()
    {
        let currentLevelAction = SKAction.sequence(generateCurrentLevelActions())
        let recursionAction = SKAction.runBlock {
            self.game.gameLevel++
            self.physicsWorld.speed = self.gameSpeed
            self.performOneLevelActions()
        }
        runAction(SKAction.sequence([currentLevelAction, recursionAction]))
    }
    
    // MARK: Setup functions
    private func pauseGameSetup()
    {
        // pause button
        pauseButtonNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        pauseButtonNode.position = CGPoint(x: size.width - Geometry.PauseButtonRightOffset, y: size.height - Geometry.PauseButtonUpperOffset)
        pauseButtonNode.name = NodeName.PauseButton
        pauseButtonNode.zPosition = ZPosition.PauseButton
        addChild(pauseButtonNode)
    }
    
    private func scoreLabelSetup()
    {
        scoreLabelNode.text = Price.cashString(game.cash)!
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
        physicsWorld.speed = gameSpeed
        // create floor physics body
        physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0.0, y: adBottomOffset), toPoint: CGPoint(x: size.width, y: adBottomOffset))
        physicsBody?.restitution = Physics.BlockRestitution
    }
    
    private func mrMarketSetup()
    {
        // add mr market
        let mrMarketWidth: CGFloat = size.width * Geometry.MrMarketRelativeWidth
        let mrMarketHeight: CGFloat = mrMarketWidth / Geometry.MrMarketAspectRatio
        mrMarket = MrMarket(textureAtlas: textureAtlas, size: CGSizeMake(mrMarketWidth, mrMarketHeight), level: game.market.level)
        mrMarket?.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mrMarket!.position = CGPoint(x: Geometry.MrMarketLeftOffset, y: size.height - Geometry.MrMarketTopOffset)
        mrMarket!.name = NodeName.MrMarket
        mrMarket!.level = game.market.level
        addChild(mrMarket!)
    }
    
    
    private func generateCurrentLevelActions() -> [SKAction]
    {
        let numberOfPeriods = game.numberOfPeriods
        let numberOfCompanies = game.companies.count
        
        var result: [SKAction] = []
        
        for i in 0..<numberOfPeriods {
            
            for j in 0..<numberOfCompanies {
                
                let oneBlockAction = SKAction.runBlock { [unowned self] in
                    
                    let company = self.game.companies[j]
                    let itemTexture = SKTexture(imageNamed: Texture.blockImageNamePrefix + "\(j)")
                    let price = company.newPriceWithMarketReturn(self.game.market.latestReturn)
                    
                    let newBlock = Block(price: price, itemTexture: itemTexture, size: self.blockSize)
                    //random position
                    let randomBlockPosition = CGFloat(arc4random_uniform(UInt32(Geometry.BlocksPerLine))) // Random number between 0 and n-1
                    let blockX = (Geometry.BlockHorizontalSeparation + self.blockSize.width / 2.0) + randomBlockPosition * (self.blockSize.width + Geometry.BlockHorizontalSeparation)
                    let blockY = self.size.height + self.blockSize.height / 2.0
                    newBlock.position = CGPoint(x: blockX, y: blockY)
                    self.existingBlocks.append(newBlock)
                    self.addChild(newBlock)
                    self.updateBlockColors()
                }
                
                let waitAction = SKAction.waitForDuration(timeBetweenBlocks)
                
                result.append(oneBlockAction)
                result.append(waitAction)
            }
            result.append(SKAction.waitForDuration(timeBetweenPeriods))
            result.append(SKAction.runBlock{
                    self.mrMarket!.level = self.game.market.newMarketLevel()
                })
        }
        return result
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
        if !backgroundMusicPlayer.playing && isMusicOn {
            backgroundMusicPlayer.play()
        }
    }
    
    // MARK: UI Effects
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
    
    private func explosion(position: CGPoint)
    {
        var emitterNode = SKEmitterNode(fileNamed: Filename.SparkEmitter)

        emitterNode.position = position
        
        let explodeAction = SKAction.runBlock { self.addChild(emitterNode) }
        let waitAction = SKAction.waitForDuration(Time.BlockExplosion)
        let disappearAction = SKAction.runBlock { emitterNode.removeFromParent() }
        
        runAction(SKAction.sequence([explodeAction, waitAction, disappearAction]))
    }
    
    private func updateBlockColors() {
        for block in existingBlocks {
            if !block.isDescending {
                block.updateColor()
            }
        }
    }
    
    // MARK: Physics contact
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if let blockA = nodeA as? Block {
            if let blockB = nodeB as? Block {
                // blockA collided with blockB
                if !blockA.isDescending || !blockB.isDescending {
                    if blockA.isDescending { game.portfolio.buyPrice(blockA.price) }
                    if blockB.isDescending { game.portfolio.buyPrice(blockB.price) }
                    runAction(slamSoundAction)
                    blockA.isDescending = false
                    blockB.isDescending = false
                    if blockA.position.y + blockA.size.height / 2.0 > size.height || blockB.position.y + blockB.size.height / 2.0 > size.height {
                        gameOver()
                    }
                }
            } else {
                // blockA collided with floor
                game.portfolio.buyPrice(blockA.price)
                runAction(slamSoundAction)
                blockA.isDescending = false
            }
        } else {
            // blockB collided with floor
            if let blockB = nodeB as? Block {
                game.portfolio.buyPrice(blockB.price)
                runAction(slamSoundAction)
                blockB.isDescending = false
            }
        }
        
        updateBlockColors()
    }
    
    // MARK: User Interaction
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(location)
        if let name = touchedNode.name {
            switch name {
                
            case NodeName.PauseButton:
                pauseGame()
                
            case NodeName.ContinueButton:
                unpauseGame()

            case NodeName.RestartButton:
                // Retart game music
                backgroundMusicPlayer.stop()
                backgroundMusicPlayer.currentTime = 0
                // Create and configure new scene
                let newGameScene = MarketGameScene(size: size)
                newGameScene.scaleMode = .AspectFill
                newGameScene.marketGameViewController = marketGameViewController
                newGameScene.adBottomOffset = adBottomOffset
                // Transition
                let newGameTransition = SKTransition.crossFadeWithDuration(1.0)
                view?.presentScene(newGameScene, transition: newGameTransition)
                
            case NodeName.QuitButton:
                if marketGameViewController != nil {
                    if backgroundMusicPlayer.playing { backgroundMusicPlayer.stop() }
                    marketGameViewController!.performSegueWithIdentifier(SegueId.QuitGame, sender: marketGameViewController!)
                }
                
            case NodeName.MusicOnOff:
                isMusicOn = !isMusicOn
                if let musicOnOffNode = touchedNode as? SKSpriteNode {
                    musicOnOffNode.texture = SKTexture(imageNamed: isMusicOn ? Filename.MusicOn : Filename.MusicOff)
                }
                
            case NodeName.ShareButton:
                let sharingText = "I got " + Price.cashString(game.cash)! + " from Mr. Market!! Can you beat me?"
                let sharingURL = NSURL(string: URLString.AppStoreDownload)
                // TODO: sharingImage
                marketGameViewController!.shareTextImageAndURL(sharingText: sharingText, sharingImage: nil, sharingURL: sharingURL)
                
            case NodeName.RateButton:
                let ratingURL = NSURL(string: URLString.AppStoreRate)
                if ratingURL != nil {
                    UIApplication.sharedApplication().openURL(ratingURL!)
                }
                
            case NodeName.RemoveAdsButton:
                if marketGameViewController != nil {
                    marketGameViewController!.performSegueWithIdentifier(SegueId.RemoveAds, sender: marketGameViewController!)
                }
                
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

    
    private func deleteBlock(block: Block) {
        if let index = find(existingBlocks, block) {
            game.portfolio.sellPrice(block.price)
            scoreLabelNode.text = Price.cashString(self.game.cash)!
            existingBlocks.removeAtIndex(index)
            block.disappear()
        }
    }
    
    // MARK: Game Finished
    
    private func gameOver()
    {
        removeAllActions()
        shakeNode(mrMarket!)
        // TODO: game over sound here
        explodeAllBlocks()
        backgroundMusicPlayer.stop()
        backgroundMusicPlayer.currentTime = 0
        // Present game over node or scene
        let waitAction = SKAction.waitForDuration(Time.GameOverNodePresentation)
        let presentGameOverScreenAction = SKAction.runBlock {
            self.isGameOver = true
            self.pauseButtonNode.hidden = true
            self.scoreLabelNode.hidden = true
            if self.gameOverNode == nil {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let newScore = self.game.cash
                var bestScore = defaults.doubleForKey(UserDefaultsKey.BestScore)
                if newScore > bestScore {
                    defaults.setDouble(newScore, forKey: UserDefaultsKey.BestScore)
                    bestScore = newScore
                }
                self.marketGameViewController!.reportScoreForCash(newScore)
                
                self.gameOverNode = GameOverNode(size: self.size, score: Price.cashString(newScore)!, bestScore: Price.cashString(bestScore)!, musicOn: self.isMusicOn)
                self.gameOverNode!.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
                self.gameOverNode!.zPosition = ZPosition.GameOverNode
                self.gameOverNode!.alpha = 0.0
                self.addChild(self.gameOverNode!)
                self.gameOverNode!.runAction(SKAction.fadeAlphaTo(1.0, duration: Time.GameOverNodeFadeIn))
            }
        }
        runAction(SKAction.sequence([waitAction, presentGameOverScreenAction]))
    }
    
    private func explodeAllBlocks() {
        for var i = existingBlocks.count - 1; i >= 0; i-- {
            let block = existingBlocks[i]
            explosion(block.position)
            deleteBlock(block)
        }
    }
    
    // MARK: Pause/Unpause
    func pauseGame() {
        if isGamePaused || isGameOver { return }
        isGamePaused = true
        paused = true
        if backgroundMusicPlayer.playing {
            backgroundMusicPlayer.pause()
        }
        // Display pause screen etc
        if pauseNode == nil {
            pauseButtonNode.hidden = true
            pauseNode = PauseNode(size: size, musicOn: isMusicOn)
            pauseNode!.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            pauseNode!.zPosition = ZPosition.PauseNode
            addChild(pauseNode!)
        }
    }
    
    func unpauseGame() {
        if !isGamePaused { return }
        isGamePaused = false
        paused = false
        if !backgroundMusicPlayer.playing && isMusicOn {
            backgroundMusicPlayer.play()
        }
        // Hide pause screen etc
        pauseNode?.removeFromParent()
        pauseNode = nil
        pauseButtonNode.hidden = false
    }

    
    private func registerAppTransitionObservers() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "applicationWillResignActive", name:UIApplicationWillResignActiveNotification , object: nil)
        
        notificationCenter.addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func applicationWillResignActive() {
        if !isGamePaused && !isGameOver { // Pause the game if necessary
            pauseGame()
        }
    }
    
    func applicationDidBecomeActive() {
        self.view?.paused = false // Unpause SKView. This is safe to call even if the view is not paused.
        if isGamePaused {
            paused = true
        }
    }
    
    func applicationDidEnterBackground() {
        backgroundMusicPlayer.stop()
        self.view?.paused = true
    }
    
    // Unpausing the view automatically unpauses the scene (and the physics simulation). Therefore, we must manually pause the scene again, if the game is supposed to be in a paused state.
    func applicationWillEnterForeground() {
        self.view?.paused = false //Unpause SKView. This is safe to call even if the view is not paused.
        if isGamePaused {
            paused = true
        }
    }
    
    // MARK: Deallocation
    override func willMoveFromView(view: SKView) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    
}
