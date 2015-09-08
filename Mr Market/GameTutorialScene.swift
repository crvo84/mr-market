//
//  GameTutorialScene.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class GameTutorialScene: SKScene, SKPhysicsContactDelegate {
    
    weak var tutorialViewController: TutorialViewController?
    
    // To create content only once
    private var contentCreated = false
    
    // Ad bottom offset (Must be set before scene is presented)
    var adBottomOffset: CGFloat = 0.0
    
    // Floor offset
    var floorOffset: CGFloat {
        get {
            var offset = size.height * Geometry.FloorRelativeHeight
            return max(adBottomOffset, offset)
        }
    }
    
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    // Audio
    private let popSoundAction = SKAction.playSoundFileNamed(Filename.PopSound, waitForCompletion: false)
    private let slamSoundAction = SKAction.playSoundFileNamed(Filename.SlamSound, waitForCompletion: false)
    private let moneySoundAction = SKAction.playSoundFileNamed(Filename.MoneySound, waitForCompletion: false)
    
    // Texture
    private let textureAtlas = SKTextureAtlas(named: Filename.SpritesAtlas)
    
    // Market
    private var mrMarket: MrMarket?
    
    // Blocks
    private var company: Company = Company(uniqueName: TutorialBlock.CompanyName, beta: TutorialBlock.CompanyBeta)
    private let itemTexture = SKTexture(imageNamed: Texture.blockImageNamePrefix + "\(TutorialBlock.ItemNumber)")
    private var existingBlocks: [Block] = []
    private var blockSize: CGSize {
        // block size
        let blockWidth = (size.width - Geometry.BlockHorizontalSeparation * (Geometry.BlocksPerLine + 1)) / Geometry.BlocksPerLine
        return CGSize(width: blockWidth, height: (size.height - floorOffset) / Geometry.BlocksPerColumn)
    }
    private var readyForExplosion: Bool = false
    private var readyForSale: Bool = false
    
    override func didMoveToView(view: SKView) {
        
        if !contentCreated {
            userInteractionEnabled = true
            backgroundColor = Color.TutorialBackground
            floorSetup()
            physicsWorldSetup()
            buttonsSetup()
            purchaseTutorial()
            
            contentCreated = true
        }
    }
    
    private func floorSetup()
    {
        let tileTexture = SKTexture(imageNamed: Filename.GrassTile)
        let tileRatio = tileTexture.size().width / tileTexture.size().height
        let tileSize = CGSize(width: floorOffset * tileRatio, height: floorOffset)
        
        var numberOfTiles: Int = Int(size.width / tileSize.width) + 1
        for i in 0..<numberOfTiles {
            let tileNode = SKSpriteNode(texture: tileTexture, color: SKColor.clearColor(), size: tileSize)
            tileNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            tileNode.position = CGPoint(x: tileSize.width * CGFloat(i), y: floorOffset)
            tileNode.zPosition = ZPosition.Floor
            addChild(tileNode)
        }
    }

    private func physicsWorldSetup()
    {
        // set up physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: Physics.Gravity)
        physicsWorld.speed = Tutorial.Speed
        // create floor physics body
        physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0.0, y: floorOffset), toPoint: CGPoint(x: size.width, y: floorOffset))
        physicsBody?.restitution = Physics.BlockRestitution
    }
    
    private func buttonsSetup()
    {
        // exit button
        let exitButtonNode = SKSpriteNode(imageNamed: Filename.Home)
        exitButtonNode.size = CGSize(width: Geometry.TutorialExitButtonSideSize, height: Geometry.TutorialExitButtonSideSize)
        exitButtonNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        exitButtonNode.position = CGPoint(x: Geometry.TutorialExitButtonLeftOffset , y: size.height - Geometry.TutorialExitButtonUpperOffset)
        exitButtonNode.name = NodeName.QuitButton
        exitButtonNode.zPosition = ZPosition.Button
        addChild(exitButtonNode)
        
        // next button
        let nextButtonNode = SKSpriteNode(imageNamed: Filename.NextButton)
        nextButtonNode.size = CGSize(width: Geometry.TutorialNextButtonSideSize, height: Geometry.TutorialNextButtonSideSize)
        nextButtonNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        nextButtonNode.position = CGPoint(x: size.width - Geometry.TutorialNextButtonRightOffset, y: size.height - Geometry.TutorialNextButtonUpperOffset)
        nextButtonNode.name = NodeName.NextButton
        nextButtonNode.zPosition = ZPosition.Button
        addChild(nextButtonNode)
        
        // reload Button
        let reloadButtonNode = SKSpriteNode(imageNamed: Filename.ReloadButton)
        reloadButtonNode.size = CGSize(width: Geometry.TutorialReloadButtonSideSize, height: Geometry.TutorialReloadButtonSideSize)
        reloadButtonNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        reloadButtonNode.position = CGPoint(x: Geometry.TutorialReloadButtonLeftOffset, y: Geometry.TutorialReloadButtonLowerOffset)
        reloadButtonNode.name = NodeName.ReloadButton
        reloadButtonNode.zPosition = ZPosition.Button
        addChild(reloadButtonNode)
    }
    
    private func mrMarketSetup()
    {
        // add mr market
        let mrMarketWidth: CGFloat = size.width * Geometry.MrMarketRelativeWidth
        let mrMarketHeight: CGFloat = mrMarketWidth / Geometry.MrMarketAspectRatio
        mrMarket = MrMarket(textureAtlas: textureAtlas, size: CGSizeMake(mrMarketWidth, mrMarketHeight), level: MrMarket.Info.MinLevel)
        mrMarket?.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mrMarket!.position = CGPoint(x: Geometry.MrMarketLeftOffset, y: size.height - Geometry.MrMarketTopOffset)
        mrMarket!.name = NodeName.MrMarket
        mrMarket!.level = MrMarket.Info.MinLevel // TODO: set level at init (check MrMarket code)
        addChild(mrMarket!)
    }
    
    private struct TutorialBlock {
        static let NameA = "blockA"
        static let NameB = "blockB"
        static let PriceValueA: Double = 10
        static let PriceValueB: Double = 15
        static let CompanyName = "TutorialCompany"
        static let CompanyBeta: Double = 1.0
        static let ItemNumber: Int = 3
    }
    
    
    // MARK: TUTORIAL
    
    private func purchaseTutorial() {
        let purchaseLabel = labelNodeWithText(Text.Purchase, atHeight: size.height / 2.0, withAlpha: 0.0)
        addChild(purchaseLabel)
        
        let waitLabelAction = SKAction.waitForDuration(Time.TutorialLabelOnScreen)
        let fadeInLabelAction = SKAction.fadeInWithDuration(Time.TutorialLabelOnScreen)
        let fadeOutLabelAction = SKAction.fadeOutWithDuration(Time.TutorialLabelOnScreen)
        let startTutorialAction = SKAction.runBlock {
            self.createBlockWithPrice(TutorialBlock.PriceValueA)
        }
        let removeLabelAction = SKAction.removeFromParent()
        purchaseLabel.runAction(SKAction.sequence([waitLabelAction, fadeInLabelAction, waitLabelAction, fadeOutLabelAction, startTutorialAction, removeLabelAction]))
    }
    
//    private func
    
    private func createBlockWithPrice(priceValue: Double) {
        company.currentPriceValue = priceValue
        let price = Price(company: company, value: company.currentPriceValue)
        let newBlock = Block(price: price, itemTexture: itemTexture, size: self.blockSize)
        // position
        let blockPosition = CGFloat(Int(Geometry.BlocksPerLine / 2))
        let blockX = (Geometry.BlockHorizontalSeparation + self.blockSize.width / 2.0) + blockPosition * (self.blockSize.width + Geometry.BlockHorizontalSeparation)
        let blockY = self.size.height + self.blockSize.height / 2.0
        newBlock.position = CGPoint(x: blockX, y: blockY)
        self.existingBlocks.append(newBlock)
        self.addChild(newBlock)
    }
    
    private func labelNodeWithText(text: String, atHeight: CGFloat, withAlpha alpha: CGFloat) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontColor = Color.TutorialLabel
        labelNode.fontName = FontName.TutorialLabel
        labelNode.fontSize = isIpad ? FontSize.TutorialLabelIpad : FontSize.TutorialLabelIphone
        labelNode.verticalAlignmentMode = .Center
        labelNode.horizontalAlignmentMode = .Center
        labelNode.position = CGPoint(x: size.width / 2.0, y: atHeight)
        labelNode.zPosition = ZPosition.TutorialLabel
        labelNode.alpha = alpha
        
        return labelNode
    }
    
//    private func generateCurrentLevelActions() -> [SKAction]
//    {
//        let numberOfPeriods = game.numberOfPeriods
//        let numberOfCompanies = game.companies.count
//        
//        var result: [SKAction] = []
//        
//        for i in 0..<numberOfPeriods {
//            
//            for j in 0..<numberOfCompanies {
//                
//                let oneBlockAction = SKAction.runBlock { [unowned self] in
//                    
//                    let company = self.game.companies[j]
//                    
//                    if !GameOption.UpdateAllPricesSimultaneously {
//                        company.newPriceWithMarketReturn(self.game.market.latestReturn)
//                    }
//                    
//                    let price = Price(company: company, value: company.currentPriceValue)
//                    
//                    let itemTexture = SKTexture(imageNamed: Texture.blockImageNamePrefix + "\(j)")
//                    let newBlock = Block(price: price, itemTexture: itemTexture, size: self.blockSize)
//                    //random position
//                    let randomBlockPosition = CGFloat(arc4random_uniform(UInt32(Geometry.BlocksPerLine))) // Random number between 0 and n-1
//                    let blockX = (Geometry.BlockHorizontalSeparation + self.blockSize.width / 2.0) + randomBlockPosition * (self.blockSize.width + Geometry.BlockHorizontalSeparation)
//                    let blockY = self.size.height + self.blockSize.height / 2.0
//                    newBlock.position = CGPoint(x: blockX, y: blockY)
//                    self.existingBlocks.append(newBlock)
//                    self.addChild(newBlock)
//                    self.updateBlockColors()
//                }
//                
//                let waitAction = SKAction.waitForDuration(timeBetweenBlocks)
//                
//                result.append(oneBlockAction)
//                result.append(waitAction)
//            }
//            result.append(SKAction.waitForDuration(timeBetweenPeriods))
//            result.append(SKAction.runBlock{
//                self.mrMarket!.level = self.game.market.newMarketLevel()
//                if GameOption.UpdateAllPricesSimultaneously {
//                    Company.newPricesWithMarketReturn(self.game.market.latestReturn, forCompanies: self.game.companies)
//                }
//                })
//        }
//        return result
//    }
    
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
                runAction(slamSoundAction)
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
                
            case NodeName.ReloadButton:
                // Create and configure new scene
                let newGameTutorialScene = GameTutorialScene(size: size)
                newGameTutorialScene.scaleMode = .AspectFill
                newGameTutorialScene.tutorialViewController = tutorialViewController
                newGameTutorialScene.adBottomOffset = adBottomOffset
                // Transition
                let newGameTransition = SKTransition.crossFadeWithDuration(0.5)
                view?.presentScene(newGameTutorialScene, transition: newGameTransition)
                
            case NodeName.QuitButton:
                if tutorialViewController != nil {
                    tutorialViewController!.performSegueWithIdentifier(SegueId.QuitTutorial, sender: tutorialViewController!)
                }
                
            default:
                break
            }
        } else if !view!.paused {
            // Blocks must not have name
            if let body = physicsWorld.bodyAtPoint(location) {
                if let blockNode = body.node as? Block {
                    if blockNode.isDescending {
                        if readyForExplosion {
                            runAction(popSoundAction)
                            explosion(blockNode.position)
                            deleteBlock(blockNode)
                        }
                    } else {
                        if readyForSale {
                            deleteBlock(blockNode)
                            runAction(moneySoundAction)
                        }
                    }
                }
            }
        }
    }
    
    
    private func deleteBlock(block: Block) {
        if let index = find(existingBlocks, block) {
            existingBlocks.removeAtIndex(index)
            block.disappear()
        }
    }
}
