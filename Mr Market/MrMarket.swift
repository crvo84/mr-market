//
//  MrMarket.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation
import SpriteKit

class MrMarket: SKSpriteNode
{
    private let textureAtlas: SKTextureAtlas

    private struct Filename {
        static let texturePrefix = "FaceMan"
    }
    
    struct Info {
        static let NumberOfTexturesTotal = 5
        static let BoomLevel = 0
        static let BurstLevel = 3
        static let MaxLevel = Info.NumberOfTexturesTotal - 1
        static let MinLevel = 0
    }
    
    
    // MARK: Initialization
    
    init(textureAtlas: SKTextureAtlas, size: CGSize, level: Int) {
        self.textureAtlas = textureAtlas
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        texture = textureForLevel(level)
        
        zPosition = ZPosition.MrMarket
        self.level = level
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Mr Market Setup
    
    var level: Int = Info.MinLevel {
        didSet {
            if level > Info.MaxLevel { level = Info.MinLevel }
            if level < Info.MinLevel { level = Info.MaxLevel }
            texture = textureForLevel(level)
            println("Mr Market. Level: \(level)")
        }
    }
    
    // Return the corresponding texture for the given level.
    private func textureForLevel(level: Int) -> SKTexture
    {
        return textureAtlas.textureNamed(Filename.texturePrefix + "\(level)")
    }
    
    
    
    
    
    
    
    
    
    
    

}