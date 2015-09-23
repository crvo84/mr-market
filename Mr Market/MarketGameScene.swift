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
    
    // To create content only once
    private var contentCreated = false
    
    // Ad bottom offset (Must be set before scene is presented)
    var adBottomOffset: CGFloat = 0.0
    
    // Floor offset
    var floorOffset: CGFloat {
        get {
            let offset = size.height * Geometry.FloorRelativeHeight
            return max(adBottomOffset, offset)
        }
    }
    
    // MrMarketGame
    private let game = MrMarketGame()
    
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    // Pause
    private var isGamePaused = false
    private var isGameOver = false
    private var successfulGame = false
    private var ranOutOfCash = false
    private let pauseButtonNode = SKSpriteNode(imageNamed: Filename.PauseButton)
    private var pauseNode: PauseNode?
    
    // Alert background music
    private var alertBackgroundMusicPlayer: AVAudioPlayer!
    
    // Get Cash
    private var isGetCashCountActive = false
    // get cash label
    private var getCashLabelBackground: SKShapeNode?
    private var getCashLabelAction: SKAction?
    // get cash counter
    private var getCashCounter: SKLabelNode?
    private var getCashCounterBackground: SKShapeNode?
    private var getCashCounterAction: SKAction?
    
    
    // Game Over
    private var gameOverNode: GameOverNode?
    
    // Score
    private let scoreLabelNode = SKLabelNode(fontNamed: FontName.ScoreLabel)
    
    // Audio
    private let popSoundAction = SKAction.playSoundFileNamed(Filename.PopSound, waitForCompletion: false)
    private let slamSoundAction = SKAction.playSoundFileNamed(Filename.SlamSound, waitForCompletion: false)
    private let moneySoundAction = SKAction.playSoundFileNamed(Filename.MoneySound, waitForCompletion: false)
    private let newLevelSoundAction = SKAction.playSoundFileNamed(Filename.SuccessSound, waitForCompletion: false)
    private let gameOverSoundAction = SKAction.playSoundFileNamed(Filename.GameOverSound, waitForCompletion: false)
    private var isMusicOn: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.MusicOn) }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserDefaultsKey.MusicOn) }
    }
    
    // Speed
    private var gameSpeed: CGFloat {
        let deviceHeightAdjustingFactor = CGFloat((size.height - floorOffset) / Geometry.DeviceBaseHeight)
        return (GameOption.SpeedInitial + GameOption.SpeedIncrease * CGFloat(game.gameLevel - 1)) * deviceHeightAdjustingFactor
    }
    
    private var timeBetweenBlocks: Double {
        let deviceHeightAdjustingFactor = Double((size.height - floorOffset) / Geometry.DeviceBaseHeight)
        return Time.BetweenBlocksForInitialSpeed / Double(gameSpeed) * deviceHeightAdjustingFactor
    }
    
    private var timeBetweenPeriods: Double {
        let deviceHeightAdjustingFactor = Double((size.height - floorOffset) / Geometry.DeviceBaseHeight)
        print("Device height adjusting factor: \(deviceHeightAdjustingFactor)")
        return Time.BetweenPeriodsForInitialSpeed / Double(gameSpeed) / Double(game.companies.count) * deviceHeightAdjustingFactor
    }
    
    // UI Level
    private var UILevel: Int = 1
    private var gameLevelsForNextUILevel: Int = GameOption.GameLevelsPerUILevelInitial {
        didSet { if gameLevelsForNextUILevel < 0 { gameLevelsForNextUILevel == 0 } }
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
        return CGSize(width: blockWidth, height: (size.height - floorOffset) / Geometry.BlocksPerColumn)
    }
    
    override func didMoveToView(view: SKView) {
        
        if !contentCreated {
            userInteractionEnabled = true
            backgroundColor = Color.MainBackground
            audioSetup()
            registerAppTransitionObservers()
            floorSetup()
            mrMarketSetup()
            physicsWorldSetup()
            scoreLabelAndPauseButtonSetup()
            
            contentCreated = true
            
            performOneLevelActions()
        }
    }
    
    private func floorSetup() {
        let tileTexture = SKTexture(imageNamed: Filename.GrassTile)
        let tileRatio = tileTexture.size().width / tileTexture.size().height
        let tileSize = CGSize(width: floorOffset * tileRatio, height: floorOffset)
        
        let numberOfTiles: Int = Int(size.width / tileSize.width) + 1
        for i in 0..<numberOfTiles {
            let tileNode = SKSpriteNode(texture: tileTexture, color: SKColor.clearColor(), size: tileSize)
            tileNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            tileNode.position = CGPoint(x: tileSize.width * CGFloat(i), y: floorOffset)
            tileNode.zPosition = ZPosition.Floor
            addChild(tileNode)
        }
    }
    
    private func performOneLevelActions()
    {
        let currentLevelAction = SKAction.sequence(generateCurrentLevelActions())
        let recursionAction = SKAction.runBlock {
            self.game.gameLevel++
            self.physicsWorld.speed = self.gameSpeed
            print("Game speed: \(self.gameSpeed)")
            self.performOneLevelActions()
        }
        runAction(SKAction.sequence([currentLevelAction, recursionAction]))
    }
    
    // MARK: Setup functions
    private func scoreLabelAndPauseButtonSetup()
    {
        // score label
        scoreLabelNode.text = Price.cashString(game.cash)!
        scoreLabelNode.fontColor = Color.ScoreLabelInitial
        scoreLabelNode.fontSize = isIpad ? FontSize.ScoreLabelIpad : FontSize.ScoreLabelIphone
        scoreLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabelNode.position = CGPoint(x: size.width / 2.0 , y: size.height - Geometry.ScoreLabelUpperOffset)
        scoreLabelNode.zPosition = ZPosition.ScoreLabel
        updateScoreLabel()
        addChild(scoreLabelNode)
        
        // pause button
        let calculatedPauseButtonSide = scoreLabelNode.frame.size.height + (Geometry.ScoreLabelUpperOffset - Geometry.PauseButtonUpperOffset) * 2
        let pauseButtonSide = max(Geometry.PauseButtonMinimumSideSize, calculatedPauseButtonSide)
        pauseButtonNode.size = CGSize(width: pauseButtonSide, height: pauseButtonSide)
        pauseButtonNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        pauseButtonNode.position = CGPoint(x: size.width - Geometry.PauseButtonRightOffset, y: size.height - Geometry.PauseButtonUpperOffset)
        pauseButtonNode.name = NodeName.PauseButton
        pauseButtonNode.zPosition = ZPosition.Button
        addChild(pauseButtonNode)
    }
    
    private func physicsWorldSetup()
    {
        // set up physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: Physics.Gravity)
        physicsWorld.speed = gameSpeed
        // create floor physics body
        physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0.0, y: floorOffset), toPoint: CGPoint(x: size.width, y: floorOffset))
        physicsBody?.restitution = Physics.BlockRestitution
    }
    
    private func mrMarketSetup()
    {
        // add mr market
        let mrMarketWidth: CGFloat = size.width * Geometry.MrMarketRelativeWidth
        let mrMarketHeight: CGFloat = mrMarketWidth / Geometry.MrMarketAspectRatio
        mrMarket = MrMarket(textureAtlas: textureAtlas, size: CGSizeMake(mrMarketWidth, mrMarketHeight), level: game.market.level)
        mrMarket?.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mrMarket!.position = CGPoint(x: Geometry.MrMarketLeftOffset, y: size.height - Geometry.MrMarketUpperOffset)
        mrMarket!.name = NodeName.MrMarket
        mrMarket!.level = game.market.level
        addChild(mrMarket!)
    }
    
    
    private func generateCurrentLevelActions() -> [SKAction]
    {
        let numberOfPeriods = game.numberOfPeriods
        let numberOfCompanies = game.companies.count
        
        var result: [SKAction] = []
        
        // Level label
        if GameOption.UILevelActivated {
            if gameLevelsForNextUILevel == 0 || game.gameLevel == 1 {
                let newLevelAction = SKAction.runBlock {
                    self.showLevelLabel()
                    self.updateUILevelInfo()
                }
                let waitLevelAction = SKAction.waitForDuration(Time.LevelLabelFadeInOut * 2 + Time.LevelLabelOnScreen)
                result.append(SKAction.sequence([newLevelAction, waitLevelAction]))
            }
            gameLevelsForNextUILevel--
        }
        
        // Blocks generation
        for _ in 0..<numberOfPeriods {
            
            for j in 0..<numberOfCompanies {
                
                let oneBlockAction = SKAction.runBlock { [unowned self] in
                    
                    let company = self.game.companies[j]

                    if !GameOption.UpdateAllPricesSimultaneously {
                        company.newPriceWithMarketReturn(self.game.market.latestReturn)
                    }

                    let price = Price(company: company, value: company.currentPriceValue)
                    
                    let itemTexture = SKTexture(imageNamed: company.name)
                    let newBlock = Block(price: price, itemTexture: itemTexture, size: self.blockSize)
                    //random position
                    let randomBlockPosition = CGFloat(arc4random_uniform(UInt32(Geometry.BlocksPerLine))) // Random number between 0 and n-1
                    let blockX = (Geometry.BlockHorizontalSeparation + self.blockSize.width / 2.0) + randomBlockPosition * (self.blockSize.width + Geometry.BlockHorizontalSeparation)
                    let blockY = self.size.height + self.blockSize.height / 2.0
                    newBlock.position = CGPoint(x: blockX, y: blockY)
                    self.existingBlocks.append(newBlock)
                    self.addChild(newBlock)
                    if !GameOption.UpdateAllPricesSimultaneously {
                        self.updateBlockColors()
                    }
                }
                
                let waitAction = SKAction.waitForDuration(timeBetweenBlocks)
                
                result.append(oneBlockAction)
                result.append(waitAction)
            }
            
            result.append(SKAction.waitForDuration(timeBetweenPeriods))
            result.append(SKAction.runBlock{
                    self.mrMarket!.level = self.game.market.newMarketLevel()
                    if GameOption.UpdateAllPricesSimultaneously {
                        Company.newPricesWithMarketReturn(self.game.market.latestReturn, forCompanies: self.game.companies)
                        self.updateBlockColors()
                    }
                })
        }
        return result
    }
    
    private func audioSetup()
    {
        // setup background music
        if backgroundMusicPlayer == nil {
            if let backgroundMusicURL = NSBundle.mainBundle().URLForResource(Filename.BackgroundMusic, withExtension: nil) {
                backgroundMusicPlayer = try? AVAudioPlayer(contentsOfURL: backgroundMusicURL)
                backgroundMusicPlayer.numberOfLoops = -1
            }
        }
        if !backgroundMusicPlayer.playing && isMusicOn {
            backgroundMusicPlayer.play()
        }
        
        // setup alert background music
        if let alertBackgroundMusicURL = NSBundle.mainBundle().URLForResource(Filename.AlertBackgroundMusic, withExtension: nil) {
            alertBackgroundMusicPlayer = try? AVAudioPlayer(contentsOfURL: alertBackgroundMusicURL)
            alertBackgroundMusicPlayer!.numberOfLoops = -1
            alertBackgroundMusicPlayer!.volume = Volume.AlertBackgroundMusic
        }
    }
    
    // MARK: UI Level
    private func showLevelLabel() {
        
        // level label
        let levelLabel = SKLabelNode(text: Text.Level + " \(UILevel)")
        levelLabel.fontSize = isIpad ? FontSize.LevelLabelIpad : FontSize.LevelLabelIphone
        levelLabel.fontName = FontName.LevelLabel
        levelLabel.fontColor = Color.LevelLabel
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.horizontalAlignmentMode = .Center
        
        // level background
        let levelBackgroundNode = backgroundNodeForLabel(levelLabel, verticalOffset: Geometry.LevelLabelBackgroundOffset, horizontalOffset: Geometry.LevelLabelBackgroundOffset, relativeCornerRadius: Geometry.LevelLabelRelativeCornerRadius)
        levelBackgroundNode.fillColor = Color.LabelBackground
        levelBackgroundNode.strokeColor = Color.LabelBackgroundBorder
        levelBackgroundNode.lineWidth = Geometry.LabelBackgroundBorderWidth
        levelBackgroundNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        levelBackgroundNode.zPosition = ZPosition.LevelLabel
        levelBackgroundNode.alpha = 0.0
        
        addChild(levelBackgroundNode)
        levelBackgroundNode.addChild(levelLabel)
        
        let fadeInAction = SKAction.fadeInWithDuration(Time.LevelLabelFadeInOut)
        let waitAction = SKAction.waitForDuration(Time.LevelLabelOnScreen)
        let fadeOutAction = SKAction.fadeOutWithDuration(Time.LevelLabelFadeInOut)
        
        levelBackgroundNode.runAction(SKAction.sequence([fadeInAction, waitAction, fadeOutAction, SKAction.removeFromParent()]))
    }

    private func updateUILevelInfo() {
        // UI Level info at game level 1 is already set as default value for properties
        if self.game.gameLevel > 1 {
            self.gameLevelsForNextUILevel = GameOption.GameLevelsPerUILevelInitial + (self.UILevel - 1) * GameOption.GameLevelsPerUILevelIncrease - 1
            self.game.addCash(GameOption.UILevelBonusInitial + Double(self.UILevel - 2) * GameOption.UILevelBonusIncrease)
            self.runAction(self.newLevelSoundAction)
            self.updateScoreLabel()
        }
        self.UILevel++
    }
    
    // MARK: Get Cash Count
    private func startGetCashCount() {
        backgroundMusicPlayer.stop()
        if isMusicOn { alertBackgroundMusicPlayer.play() }
        
        // COUNTER
        // add counter
        getCashCounter = SKLabelNode(text: "\(Int(Time.GetCashTotalCount))")
        getCashCounter!.fontColor = Color.GetCashCounter
        getCashCounter!.fontName = FontName.GetCashCounter
        getCashCounter!.fontSize = isIpad ? FontSize.GetCashCounterIpad : FontSize.GetCashCounterIphone
        getCashCounter!.verticalAlignmentMode = .Center
        getCashCounter!.horizontalAlignmentMode = .Center
        // counter background
        getCashCounterBackground = backgroundNodeForLabel(getCashCounter!, verticalOffset: Geometry.GetCashCounterBackgroundOffset, horizontalOffset: Geometry.GetCashCounterBackgroundOffset, relativeCornerRadius: Geometry.GetCashCounterBackgroundRelativeCornerRadius)
        getCashCounterBackground!.fillColor = Color.LabelBackground
        getCashCounterBackground!.strokeColor = Color.LabelBackgroundBorder
        getCashCounterBackground!.lineWidth = Geometry.LabelBackgroundBorderWidth
        let getCashCounterBackgroundNodeX = size.width - Geometry.PauseButtonRightOffset - getCashCounterBackground!.frame.size.width / 2
        let getCashCounterBackgroundNodeY = pauseButtonNode.position.y - pauseButtonNode.size.height - Geometry.GetCashCounterUpperOffset - getCashCounterBackground!.frame.size.height / 2.0
        getCashCounterBackground!.position = CGPoint(x: getCashCounterBackgroundNodeX, y: getCashCounterBackgroundNodeY)
        getCashCounterBackground!.zPosition = ZPosition.GetCashCounter
        getCashCounterBackground!.addChild(getCashCounter!)
        
        // counter action
        var counterActions: [SKAction] = []
        for var i = Time.GetCashTotalCount - 1; i >= 0; i-- {
            let currentCount = Int(i)
            counterActions.append(SKAction.waitForDuration(1.0))
            counterActions.append(SKAction.runBlock({
                self.getCashCounter?.text = "\(currentCount)"
            }))
        }
        counterActions.append(SKAction.runBlock({
            self.ranOutOfCash = true
            self.stopGetCashCount(gameOver: true)
            self.gameOver()
        }))
        getCashCounterAction = SKAction.sequence(counterActions)
        
        // LABEL
        // add label
        let getCashLabel = SKLabelNode(text: Text.GetCash)
        getCashLabel.fontColor = Color.GetCashLabel
        getCashLabel.fontName = FontName.GetCashLabel
        getCashLabel.fontSize = isIpad ? FontSize.GetCashLabelIpad : FontSize.GetCashLabelIphone
        
        let getCashBackgroundHorizontalOffset = mrMarket == nil ? getCashCounterBackground!.frame.size.width + Geometry.PauseButtonRightOffset : mrMarket!.frame.size.width + Geometry.MrMarketLeftOffset
        let maxGetCashLabelWidth = (size.width - (getCashBackgroundHorizontalOffset + Geometry.GetCashLabelBackgroundOffset) * 2) * Geometry.GetCashLabelMaxRelativeWidth
        adjustLabelFontSizeToMaximumWidth(labelNode: getCashLabel, maxWidth: maxGetCashLabelWidth)
        
        getCashLabel.verticalAlignmentMode = .Center
        getCashLabel.horizontalAlignmentMode = .Center
        // label background
        getCashLabelBackground = backgroundNodeForLabel(getCashLabel, verticalOffset: Geometry.GetCashLabelBackgroundOffset, horizontalOffset: Geometry.GetCashLabelBackgroundOffset, relativeCornerRadius: Geometry.GetCashLabelBackgroundRelativeCornerRadius)
        getCashLabelBackground!.fillColor = Color.LabelBackground
        getCashLabelBackground!.strokeColor = Color.LabelBackgroundBorder
        getCashLabelBackground!.lineWidth = Geometry.LabelBackgroundBorderWidth
        getCashLabelBackground!.position = CGPoint(x: size.width / 2.0, y: getCashCounterBackground!.position.y)
        getCashLabelBackground!.zPosition = ZPosition.GetCashLabel
        getCashLabelBackground!.addChild(getCashLabel)
        getCashLabelBackground!.alpha = 0.0 // starts hidden
        
        // label action
        var showLabelActions: [SKAction] = []
        for i in 0..<Time.GetCashLabelTimesShowed {
            let waitHiddenAction = SKAction.waitForDuration(i > 0 ? Time.GetCashLabelOnScreen : 0)
            let appearLabelAction = SKAction.fadeInWithDuration(Time.GetCashLabelFadeInOut)
            let waitOnScreenLabelAction = SKAction.waitForDuration(Time.GetCashLabelOnScreen)
            let disappearLabelAction = SKAction.fadeOutWithDuration(Time.GetCashLabelFadeInOut)
            showLabelActions.append(SKAction.sequence([waitHiddenAction, appearLabelAction, waitOnScreenLabelAction, disappearLabelAction]))
        }
        showLabelActions.append(SKAction.removeFromParent())
        getCashLabelAction = SKAction.sequence(showLabelActions)
    
        // add nodes and run actions
        addChild(getCashLabelBackground!)
        addChild(getCashCounterBackground!)
        getCashLabelBackground!.runAction(getCashLabelAction!, withKey: ActionKey.GetCashLabel)
        runAction(getCashCounterAction!, withKey: ActionKey.GetCashCounter)
    }
    
    private func stopGetCashCount(gameOver gameOver: Bool) {
        // remove actions
        getCashLabelBackground?.removeActionForKey(ActionKey.GetCashLabel)
        removeActionForKey(ActionKey.GetCashCounter)
        // remove nodes
        getCashLabelBackground?.removeFromParent()
        getCashCounter?.removeFromParent()
        getCashCounterBackground?.removeFromParent()
        // stop alert music
        alertBackgroundMusicPlayer.stop()
        if isMusicOn && !gameOver && !ranOutOfCash {
            backgroundMusicPlayer.play()
        }
        getCashLabelBackground = nil
        getCashCounter = nil
        getCashCounterBackground = nil
        getCashLabelAction = nil
        getCashCounterAction = nil
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
    
    private func shakeAllBlocks() {
        for block in existingBlocks {
            shakeNode(block)
        }
    }
    
    private func explosion(position: CGPoint)
    {
        let emitterNode = SKEmitterNode(fileNamed: Filename.SparkEmitter)
        let positionRangeX = blockSize.width * Geometry.BlockExplosionRelativeWidth
        let positionRangeY = blockSize.height * Geometry.BlockExplosionRelativeHeight
        emitterNode!.particlePositionRange = CGVector(dx: positionRangeX, dy: positionRangeY)
        
        emitterNode!.position = position
        emitterNode!.zPosition = ZPosition.Explosion
        
        self.addChild(emitterNode!)

        runAction(SKAction.waitForDuration(Time.BlockExplosion)) { () -> Void in
            emitterNode?.removeFromParent()
        }
    }
    
    private func updateBlockColors() {
        for block in existingBlocks {
            if !block.isDescending {
                block.updateColor()
            }
        }
    }
    
    // TODO: change all blocks to white color
    
    // MARK: Physics contact
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        var landedBlock: Block?
        
        if let blockA = nodeA as? Block {
            
            if let blockB = nodeB as? Block {
                if blockA.isDescending && blockB.isDescending {
                    // Both blocks collided when both were descending
                    return
                } else if blockA.isDescending {
                    landedBlock = blockA
                } else if blockB.isDescending {
                    landedBlock = blockB
                }
                
            } else {
                // blockA collided with floor
                landedBlock = blockA
            }
            
        } else {
            // blockB collided with floor
            if let blockB = nodeB as? Block {
                landedBlock = blockB
            }
        }
        
        if let blockToPurchase = landedBlock {
            if blockToPurchase.isDescending {
                blockToPurchase.isDescending = false
                
                let blockY = blockToPurchase.position.y
//                let blockHeight = blockToPurchase.size.height
                
                if game.portfolio.buyPrice(blockToPurchase.price) {
                    runAction(slamSoundAction)
                } else {
                    runAction(popSoundAction)
                    explosion(blockToPurchase.position)
                    deleteBlock(blockToPurchase)
                }
                
                if blockY >= size.height { // or blockY + blockHeight / 2.0 ?
                    gameOver()
                    return
                }
            }
        }
        
        updateScoreLabel()
        updateBlockColors()
    }
    
    // MARK: User Interaction
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
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
                    if backgroundMusicPlayer.playing {
                        backgroundMusicPlayer.stop()
                    }
                    backgroundMusicPlayer.currentTime = 0
                    marketGameViewController!.performSegueWithIdentifier(SegueId.QuitGame, sender: marketGameViewController!)
                }
                
            case NodeName.MusicOnOff:
                isMusicOn = !isMusicOn
                if let musicOnOffNode = touchedNode as? SKSpriteNode {
                    musicOnOffNode.texture = SKTexture(imageNamed: isMusicOn ? Filename.MusicOn : Filename.MusicOff)
                }
                
            case NodeName.ShareButton:
                let cashString = Price.cashString(game.cash)!
                
                let sharingText = Text.MrMarket +  "  |  " + cashString + "  |  " + Text.CanYouBeatMe
                let sharingURL = NSURL(string: URLString.AppStoreDownload)
                let sharingImage = ScoreImageGenerator().scoreImageWithText(cashString)
                
                let locationInView = touch!.locationInView(view!)
                
                marketGameViewController!.shareTextImageAndURL(sharingText: sharingText, sharingImage: sharingImage, sharingURL: sharingURL, sender: self.view!, positionInView: locationInView)
                
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
        } else if !view!.paused && !isGameOver {
            // Blocks must not have name
            if let body = physicsWorld.bodyAtPoint(location) {
                if let blockNode = body.node as? Block {
                    if blockNode.isDescending {
                        runAction(popSoundAction)
                        explosion(blockNode.position)
                        deleteBlock(blockNode)
                    } else {
                        deleteBlock(blockNode)
                        runAction(moneySoundAction)
                    }
                }
            }
        }
    }

    
    private func deleteBlock(block: Block) {
        if let index = existingBlocks.indexOf(block) {
            if !isGameOver || ranOutOfCash || !GameOption.GameOverRecoverOriginalInvestments {
                // If still playing or ran out of cash, block is sold at current value
                game.portfolio.sellPrice(block.price)
            } else {
                // If game over without running out of cash, block is sold at original value
                game.portfolio.sellPriceWithoutProfitOrLoss(block.price)
            }
            
            updateScoreLabel()
            existingBlocks.removeAtIndex(index)
            block.disappear()
        }
    }
    
    private func updateScoreLabel() {
        scoreLabelNode.text = Price.cashString(self.game.cash)!

        if !game.enoughCash() {
            scoreLabelNode.fontColor = Color.ScoreLabelNotEnoughCash
            if !isGetCashCountActive {
                startGetCashCount()
                isGetCashCountActive = true
            }
        } else {
            scoreLabelNode.fontColor = game.hasProfit() ? Color.ScoreLabelProfit : Color.ScoreLabelInitial
            if isGetCashCountActive {
                stopGetCashCount(gameOver: false)
                isGetCashCountActive = false
            }
        }
        // font size check
        if mrMarket != nil {
            let maxScoreLabelWidth = (size.width - (mrMarket!.size.width + Geometry.MrMarketLeftOffset) * 2 ) * Geometry.ScoreLabelMaxRelativeWidth
            adjustLabelFontSizeToMaximumWidth(labelNode: scoreLabelNode, maxWidth: maxScoreLabelWidth)
        }
    }
    
    // MARK: helper functions
    
    // adjusts font size if needed
    private func adjustLabelFontSizeToMaximumWidth(labelNode labelNode:SKLabelNode, maxWidth: CGFloat)
    {
        let currentWidth = labelNode.frame.size.width
        
        if currentWidth > maxWidth {
            
            // Determine the font scaling factor that should let the label text fit in the given rectangle.
            let scalingFactor = maxWidth / currentWidth
            
            // Change the fontSize.
            labelNode.fontSize *= scalingFactor
        }
    }
    
    private func backgroundNodeForLabel(labelNode: SKLabelNode, verticalOffset: CGFloat, horizontalOffset: CGFloat, relativeCornerRadius: CGFloat) -> SKShapeNode
    {
        let width = labelNode.frame.size.width + horizontalOffset * 2
        let height = labelNode.frame.size.height + verticalOffset * 2
        let backgroundCornerRadius = relativeCornerRadius * width
        let backgroundSize = CGSize(width: width, height: height)
        
        return SKShapeNode(rectOfSize: backgroundSize, cornerRadius: backgroundCornerRadius)
    }
    
    // MARK: Game Finished
    
    private func gameOver()
    {
        setAllBlocksDynamic(false)
        
        removeAllActions()
//        shakeNode(mrMarket!)
//        shakeNode(pauseButtonNode)
//        shakeNode(scoreLabelNode)
        shakeAllBlocks()
        
        isGameOver = true

        explodeDescendingBlocks()
        backgroundMusicPlayer.stop()
        backgroundMusicPlayer.currentTime = 0
        runAction(gameOverSoundAction)
        
        // Sell all blocks actions
        let sellAllBlocksAction = SKAction.sequence(sellAllBlocksActions())
        
        // Present game over node or scene
        let waitAction = SKAction.waitForDuration(Time.GameOverNodePresentation)
        let presentGameOverScreenAction = SKAction.runBlock {
            self.pauseButtonNode.hidden = true
            self.scoreLabelNode.hidden = true
            if self.gameOverNode == nil {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                
                // new score
                let newScore = self.game.cash
                
                // best score
                var bestScore = defaults.doubleForKey(UserDefaultsKey.BestScore)
                if newScore > bestScore {
                    defaults.setDouble(newScore, forKey: UserDefaultsKey.BestScore)
                    bestScore = newScore
                }
                self.marketGameViewController!.reportScoreForCash(newScore)
                
                let gameOverNodeSize = CGSize(width: self.size.width, height: self.size.height - self.adBottomOffset)
                let gameOverNodePosition = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0 + self.adBottomOffset / 2.0)
                self.gameOverNode = GameOverNode(size: gameOverNodeSize, score: Price.cashString(newScore)!, bestScore: Price.cashString(bestScore)!, musicOn: self.isMusicOn)
                self.gameOverNode!.position = gameOverNodePosition
                self.gameOverNode!.zPosition = ZPosition.GameOverNode
                self.gameOverNode!.alpha = 0.0
                self.addChild(self.gameOverNode!)
                self.gameOverNode!.runAction(SKAction.fadeAlphaTo(1.0, duration: Time.GameOverNodeFadeIn))
            }
        }
        
        runAction(SKAction.sequence([sellAllBlocksAction, waitAction, presentGameOverScreenAction]))
    }
    
    private func explodeDescendingBlocks() {
        for var i = existingBlocks.count - 1; i >= 0; i-- {
            let block = existingBlocks[i]
            if block.isDescending {
                explosion(block.position)
                deleteBlock(block)
            }
        }
    }
    
    private func setAllBlocksDynamic(dynamic: Bool) {
        for block in existingBlocks {
            block.physicsBody?.dynamic = dynamic
        }
    }
    
    private func sellAllBlocksActions() -> [SKAction] {
        var actions: [SKAction] = []
        actions.append(SKAction.waitForDuration(Time.SellAllBlocksInitialWait))
        for var i = existingBlocks.count - 1; i >= 0; i-- {
            let block = existingBlocks[i]
            if !block.isDescending {
                actions.append(SKAction.runBlock {
                    self.deleteBlock(block)
                    self.runAction(self.moneySoundAction)
                })
                actions.append(SKAction.waitForDuration(Time.SellAllBlocksBetweenBlock))
            }
        }
        actions.append(SKAction.waitForDuration(Time.SellAllBlocksFinalWait))
        return actions
    }
    
    // MARK: Pause/Unpause
    func pauseGame() {
        if isGamePaused || isGameOver { return }
        isGamePaused = true
        paused = true
        if backgroundMusicPlayer.playing {
            backgroundMusicPlayer.pause()
        }
        if alertBackgroundMusicPlayer.playing {
            alertBackgroundMusicPlayer.pause()
        }
    
        // Display pause screen etc
        if pauseNode == nil {
            pauseButtonNode.hidden = true
            let pauseNodeSize = CGSize(width: size.width, height: size.height - adBottomOffset)
            let pauseNodePosition = CGPoint(x: size.width / 2.0, y: size.height / 2.0 + adBottomOffset / 2.0)
            pauseNode = PauseNode(size: pauseNodeSize, musicOn: isMusicOn)
            pauseNode!.position = pauseNodePosition
            pauseNode!.zPosition = ZPosition.PauseNode
            addChild(pauseNode!)
        }
    }
    
    func unpauseGame() {
        if !isGamePaused { return }
        isGamePaused = false
        paused = false
        
        if isMusicOn {
            if isGetCashCountActive {
                if !alertBackgroundMusicPlayer.playing { alertBackgroundMusicPlayer.play() }
            } else {
                if !backgroundMusicPlayer.playing { backgroundMusicPlayer.play() }
            }
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
        alertBackgroundMusicPlayer.stop()
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
