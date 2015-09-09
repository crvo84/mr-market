//
//  MrMarketFaceScene.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 9/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class MrMarketFaceScene: SKScene {
    
    // To create content only once
    private var contentCreated = false
    
    // Texture
    private let textureAtlas = SKTextureAtlas(named: Filename.SpritesAtlas)
    
    // Market
    private var mrMarket: MrMarket?
    
    override func didMoveToView(view: SKView) {
        
        if !contentCreated {
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
            mrMarketSetup()
            
            contentCreated = true
        }
    }
    
    private func mrMarketSetup() {
        mrMarket = MrMarket(textureAtlas: textureAtlas, size: size, level: 0)
        // change face loop action
        let changeMoodAction = SKAction.runBlock {
            self.mrMarket!.level++
        }
        let waitAction = SKAction.waitForDuration(Time.TutorialMrMarketMoodFaceChange)
        let changeMoodLoopAction = SKAction.repeatActionForever(SKAction.sequence([changeMoodAction, waitAction]))
        mrMarket!.runAction(changeMoodLoopAction)
        
        addChild(mrMarket!)
    }
   
}
