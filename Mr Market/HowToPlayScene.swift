//
//  HowToPlayScene.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class HowToPlayScene: SKScene, SKPhysicsContactDelegate {
    
    weak var howToPlayViewController: HowToPlayViewController?
    
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
    
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    // Audio
    private let popSoundAction = SKAction.playSoundFileNamed(Filename.PopSound, waitForCompletion: false)
    private let slamSoundAction = SKAction.playSoundFileNamed(Filename.SlamSound, waitForCompletion: false)
    private let moneySoundAction = SKAction.playSoundFileNamed(Filename.MoneySound, waitForCompletion: false)
    
    // Blocks
    private var company: Company = Company(uniqueName: TutorialBlock.CompanyName, beta: TutorialBlock.CompanyBeta)
    private let itemTexture = SKTexture(imageNamed: Texture.blockImageNamePrefix + "\(TutorialBlock.ItemSuffix)")
    private var existingBlocks: [Block] = []
    private var blockSize: CGSize {
        // block size
        let blockWidth = (size.width - Geometry.BlockHorizontalSeparation * (Geometry.BlocksPerLine + 1)) / Geometry.BlocksPerLine
        return CGSize(width: blockWidth, height: (size.height - floorOffset) / Geometry.BlocksPerColumn)
    }
    
    // Tutorial Labels
    private var tutorialLabelNode: SKLabelNode?
    // Tutorial nodes
    private var touchScreenNode: SKSpriteNode?
    // Tutorial steps
    private var buyTutorialDone: Bool = false
    
    override func didMoveToView(view: SKView) {
        
        if !contentCreated {
            userInteractionEnabled = true
            backgroundColor = Color.TutorialBackground
            floorSetup()
            physicsWorldSetup()
            buttonsSetup()
            
            contentCreated = true
            
            startTutorial()
        }
    }
    
    private func floorSetup()
    {
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
        let exitButtonNode = SKSpriteNode(imageNamed: Filename.PreviousButton)
        exitButtonNode.size = CGSize(width: Geometry.TutorialExitButtonSideSize, height: Geometry.TutorialExitButtonSideSize)
        exitButtonNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        exitButtonNode.position = CGPoint(x: Geometry.TutorialExitButtonLeftOffset , y: size.height - Geometry.TutorialExitButtonUpperOffset)
        exitButtonNode.name = NodeName.QuitButton
        exitButtonNode.zPosition = ZPosition.Button
        addChild(exitButtonNode)
        
//        // reload Button
//        let reloadButtonNode = SKSpriteNode(imageNamed: Filename.ReloadButton)
//        reloadButtonNode.size = CGSize(width: Geometry.TutorialReloadButtonSideSize, height: Geometry.TutorialReloadButtonSideSize)
//        reloadButtonNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
//        reloadButtonNode.position = CGPoint(x: size.width - Geometry.TutorialReloadButtonRightOffset, y: size.height - Geometry.TutorialReloadButtonUpperOffset)
//        reloadButtonNode.name = NodeName.ReloadButton
//        reloadButtonNode.zPosition = ZPosition.Button
//        addChild(reloadButtonNode)
    }
    
    // MARK: TUTORIAL
    
    private struct TutorialBlock {
        static let NameA = "blockA"
        static let NameB = "blockB"
        static let PriceValueA: Double = 5
        static let PriceValueB: Double = 6
        static let CompanyName = "TutorialCompany"
        static let CompanyBeta: Double = 1.0
        static let ItemSuffix: Int = 3
    }
    
    private func startTutorial()
    {
        let mainTitleNode = SKLabelNode(text: Text.HowToPlay)
        mainTitleNode.fontColor = Color.TutorialMainTitle
        mainTitleNode.fontName = FontName.TutorialMainTitle
        mainTitleNode.fontSize = isIpad ? FontSize.TutorialMainTitleIpad : FontSize.TutorialMainTitleIphone
        adjustLabelFontSizeToMaximumWidth(labelNode: mainTitleNode, maxWidth: size.width * Geometry.TutorialLabelMaxRelativeWidth)
        mainTitleNode.verticalAlignmentMode = .Top
        mainTitleNode.horizontalAlignmentMode = .Center
        mainTitleNode.position = CGPoint(x: size.width / 2.0, y: (size.height + floorOffset) / 2.0)
        mainTitleNode.zPosition = ZPosition.TutorialMainTitle
        mainTitleNode.alpha = 0.0
        addChild(mainTitleNode)
        
        let fadeInAction = SKAction.fadeInWithDuration(Time.TutorialLabelFadeInOut)
        let waitAction = SKAction.waitForDuration(Time.TutorialWaitBetweenActions)
        let fadeOutAction = SKAction.fadeOutWithDuration(Time.TutorialLabelFadeInOut)
        let removeMainTitleNode = SKAction.removeFromParent()
        mainTitleNode.runAction(SKAction.sequence([fadeInAction, waitAction, fadeOutAction, removeMainTitleNode])) {
            self.buyTutorial()
        }
    }
    
    private func buyTutorial() {
        // Set Label Text
        setLabelNodeWithText(Text.Buy)
        // labelNode should have alpha 0.0
        // wait
        let waitAction = SKAction.waitForDuration(Time.TutorialWaitBetweenActions)
        // Fade in label
        let fadeInLabelAction = SKAction.fadeInWithDuration(Time.TutorialLabelFadeInOut)
        // drop block
        let createBlockAction = SKAction.runBlock {
            self.createBlockWithPrice(TutorialBlock.PriceValueA, withName: TutorialBlock.NameA)
        }
        tutorialLabelNode!.runAction(SKAction.sequence([waitAction, fadeInLabelAction, createBlockAction]))
        // when block hits the bottom, wait, fade out node and call rejectOfferTutorial
        // done at didBeginContact
    }
    
    private func rejectOfferTutorial() {
        // set label text
        setLabelNodeWithText(Text.RejectOffer)
        // labelNode should have alpha 0.0
        // wait
        let waitAction = SKAction.waitForDuration(Time.TutorialWaitBetweenActions)
        // fade in label
        let fadeInLabelAction = SKAction.fadeInWithDuration(Time.TutorialLabelFadeInOut)
        // create block and touch screen
        let createBlockAction = SKAction.runBlock {
            self.addTouchScreenPointingAt(CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0 + Geometry.TutorialTouchScreenVerticalOffsetFromCenter), withSize: nil, pointingLeft: false)
            self.createBlockWithPrice(TutorialBlock.PriceValueB, withName: TutorialBlock.NameB)
        }
        tutorialLabelNode!.runAction(SKAction.sequence([waitAction, fadeInLabelAction, createBlockAction]))
        // when the block overlaps the touchScreenNode, colorize the touchscreen, explode block, wait and then fade out label and touchScreenNode and call see tutorial
        // done at update
        
    }
    
    private func sellTutorial() {
        // set label text
        setLabelNodeWithText(Text.Sell)
        // labelNode should have alpha 0.0
        // wait
        let waitAction = SKAction.waitForDuration(Time.TutorialWaitBetweenActions)
        // fade in label
        let fadeInLabelAction = SKAction.fadeInWithDuration(Time.TutorialLabelFadeInOut)
        // add touchScreenNode
        let addTouchScreenAction = SKAction.runBlock {
            if self.existingBlocks.count > 0 {
                let blockA = self.existingBlocks[0]
                let pointingAt = CGPoint(x: self.size.width / 2.0, y: blockA.position.y)
                self.addTouchScreenPointingAt(pointingAt, withSize: nil, pointingLeft: true)
            }
        }
        // wait
        // highlight touchScreen
        let highlightTouchScreenAction = SKAction.runBlock {
            self.highlightTouchScreen()
        }
        let waitAfterHighlightAction = SKAction.waitForDuration(Time.TutorialTouchScreenFadeInOut)
        // sell block
        let sellAction = SKAction.runBlock {
            if self.existingBlocks.count > 0 {
                let blockA = self.existingBlocks[0]
                self.deleteBlock(blockA)
                self.runAction(self.moneySoundAction)
            }
        }
        
        // wait
        // remove touchscreen
        let removeTouchScreenAction = SKAction.runBlock {
            self.removeTouchScreen(animated: true)
        }
        let fadeOutTutorialAction = SKAction.fadeOutWithDuration(Time.TutorialLabelFadeInOut)
        let endTutorialAction = SKAction.runBlock {
            self.endTutorial()
        }
        
        tutorialLabelNode!.runAction(SKAction.sequence([waitAction, fadeInLabelAction, addTouchScreenAction, waitAction, highlightTouchScreenAction, waitAfterHighlightAction, sellAction, waitAction, removeTouchScreenAction, fadeOutTutorialAction, endTutorialAction]))
    }
    
    private func endTutorial() {
        
        if howToPlayViewController != nil {
            howToPlayViewController!.performSegueWithIdentifier(SegueId.QuitHowToPlay, sender: howToPlayViewController!)
        }
        
    }
    
    private func createBlockWithPrice(priceValue: Double, withName name: String) {
        company.currentPriceValue = priceValue
        let price = Price(company: company, value: company.currentPriceValue)
        let newBlock = Block(price: price, itemTexture: itemTexture, size: self.blockSize)
        // position
        let blockColumn = CGFloat(Int(Geometry.BlocksPerLine / 2))
        let blockX = (Geometry.BlockHorizontalSeparation + self.blockSize.width / 2.0) + blockColumn * (self.blockSize.width + Geometry.BlockHorizontalSeparation)
        let blockY = self.size.height + self.blockSize.height / 2.0
        newBlock.position = CGPoint(x: blockX, y: blockY)
        newBlock.name = name
        self.existingBlocks.append(newBlock)
        self.addChild(newBlock)
        
        updateBlockColors()
    }
    
    private func setLabelNodeWithText(text: String)
    {
        tutorialLabelNode?.removeFromParent()
        tutorialLabelNode = nil
        
        tutorialLabelNode = SKLabelNode(text: text)
        tutorialLabelNode!.fontColor = Color.TutorialLabel
        tutorialLabelNode!.fontName = FontName.TutorialLabel
        tutorialLabelNode!.fontSize = isIpad ? FontSize.TutorialLabelIpad : FontSize.TutorialLabelIphone
        adjustLabelFontSizeToMaximumWidth(labelNode: tutorialLabelNode!, maxWidth: size.width * Geometry.TutorialLabelMaxRelativeWidth)
        tutorialLabelNode!.verticalAlignmentMode = .Top
        tutorialLabelNode!.horizontalAlignmentMode = .Center
        tutorialLabelNode!.position = CGPoint(x: size.width / 2.0, y: size.height - Geometry.TutorialLabelUpperOffset)
        tutorialLabelNode!.zPosition = ZPosition.TutorialLabel
        tutorialLabelNode!.alpha = 0.0
        addChild(tutorialLabelNode!)
    }
    
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
    
    // pointing up
    private func addTouchScreenPointingAt(point: CGPoint, withSize nodeSize: CGSize?, pointingLeft: Bool) {
        if touchScreenNode != nil {
            removeTouchScreen(animated: false)
        }
        
        touchScreenNode = SKSpriteNode(imageNamed: Filename.TouchScreen)
        touchScreenNode!.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        touchScreenNode!.position = point
        touchScreenNode!.zPosition = ZPosition.TouchScreen
        touchScreenNode!.alpha = 0.0
        if nodeSize != nil {
            touchScreenNode!.size = nodeSize!
        }
        if pointingLeft {
            let radians = CGFloat(M_PI_2)
            touchScreenNode!.runAction(SKAction.rotateByAngle(radians, duration: 0.0))
        }
        addChild(touchScreenNode!)
        touchScreenNode!.runAction(SKAction.fadeAlphaTo(Tutorial.TouchScreenInitialAlpha, duration: Time.TutorialTouchScreenFadeInOut))
    }
    

    
    private func highlightTouchScreen() {
        touchScreenNode!.runAction(SKAction.fadeAlphaTo(Tutorial.TouchScreenFinalAlpha, duration: Time.TutorialTouchScreenHighlight))
    }
    
    private func removeTouchScreen(animated animated: Bool) {
        if touchScreenNode != nil {
            if animated {
                touchScreenNode!.runAction(SKAction.fadeOutWithDuration(Time.TutorialTouchScreenFadeInOut), completion: {
                    self.touchScreenNode!.removeFromParent()
                    self.touchScreenNode = nil
                })
            } else {
                self.touchScreenNode!.removeFromParent()
                self.touchScreenNode = nil
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
                
                // when block hits the bottom, wait, fade out node and call rejectOfferTutorial
                if let blockName = blockToPurchase.name {
                    if blockName == TutorialBlock.NameA {
//                        let waitAction = SKAction.waitForDuration(Time.TutorialWaitBetweenActions)
                        let fadeOutTutorialLabelAction = SKAction.fadeOutWithDuration(Time.TutorialLabelFadeInOut)
                        let rejectOfferTutorialAction = SKAction.runBlock {
                            self.buyTutorialDone = true
                            self.rejectOfferTutorial()
                        }
                        tutorialLabelNode!.runAction(SKAction.sequence([fadeOutTutorialLabelAction, rejectOfferTutorialAction]))
                    }
                }
            }
        }
        updateBlockColors()
    }
    
    // MARK: Frame rendering cycle
    override func update(currentTime: NSTimeInterval) {
        if buyTutorialDone {
            // when the block overlaps the touchScreenNode, colorize the touchscreen, explode block, wait and then fade out label and touchScreenNode and call see tutorial
            if existingBlocks.count > 1 && touchScreenNode != nil {
                let blockB = existingBlocks[1]
                let blockBTouchScreenDistance = blockB.position.y - touchScreenNode!.position.y
                
                
                if blockBTouchScreenDistance <= 0 {
                    
                    let explodeAction = SKAction.runBlock {
                        self.runAction(self.popSoundAction)
                        self.explosion(blockB.position)
                        self.deleteBlock(blockB)
                    }
                    let waitAction = SKAction.waitForDuration(Time.TutorialWaitBetweenActions)
                    let removeTouchScreenAction = SKAction.runBlock {
                        self.removeTouchScreen(animated: true)
                    }
                    let fadeOutTutorialAction = SKAction.fadeOutWithDuration(Time.TutorialLabelFadeInOut)
                    let sellTutorialAction = SKAction.runBlock {
                        self.sellTutorial()
                    }
                    
                    tutorialLabelNode!.runAction(SKAction.sequence([explodeAction, waitAction, removeTouchScreenAction, fadeOutTutorialAction, sellTutorialAction]))
                    
                } else if blockBTouchScreenDistance <= blockSize.height {
                    
                    highlightTouchScreen()
                    
                }
            }
        }
    }
    
    
    // MARK: User Interaction
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(location)
        if let name = touchedNode.name {
            switch name {

            case NodeName.QuitButton:
                if howToPlayViewController != nil {
                    howToPlayViewController!.performSegueWithIdentifier(SegueId.QuitHowToPlay, sender: howToPlayViewController!)
                }
                
            default:
                break
            }
        }
    }
    
    
    private func deleteBlock(block: Block) {
        if let index = existingBlocks.indexOf(block) {
            existingBlocks.removeAtIndex(index)
            block.disappear()
        }
    }
    
    private func explosion(position: CGPoint)
    {
        let emitterNode = SKEmitterNode(fileNamed: Filename.SparkEmitter)
        
        emitterNode!.position = position
        
        let explodeAction = SKAction.runBlock { self.addChild(emitterNode!) }
        let waitAction = SKAction.waitForDuration(Time.BlockExplosion)
        let disappearAction = SKAction.runBlock { emitterNode!.removeFromParent() }
        
        runAction(SKAction.sequence([explodeAction, waitAction, disappearAction]))
    }
    
    private func updateBlockColors() {
        for block in existingBlocks {
            if !block.isDescending {
                block.updateColor()
            }
        }
    }
}
