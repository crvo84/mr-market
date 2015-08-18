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
        static let NumberOfTexturesTotal: Int = 16
        static let NumberOfTexturesBeforeBurst: Int = 12 // Index 11 = Level 50% (Just before the bubble burst)
        static let NumberOfTexturesAfterBurst: Int = Info.NumberOfTexturesTotal - Info.NumberOfTexturesBeforeBurst
        static let MaxLevel: Double = 100.0
        static let MinLevel: Double = 0.0
        static let TopBubbleLevel: Double = 50.0
    }
    
    
    // MARK: Initialization
    
    init(textureAtlas: SKTextureAtlas, size: CGSize, level: Double) {
        self.textureAtlas = textureAtlas
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        texture = textureForLevel(level)
        
        zPosition = ZPosition.MrMarket
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Mr Market Setup
    
    var level: Double = Info.MinLevel {
        didSet {
            if level > Info.MaxLevel { level = Info.MinLevel }
            if level < Info.MinLevel { level = Info.MaxLevel }
            texture = textureForLevel(level)
        }
    }
    
    // Return the corresponding texture for the given level.
    private func textureForLevel(level: Double) -> SKTexture
    {
        var pointsPerIndex: Double
        var index: Int
        
        if level <= Info.TopBubbleLevel { // From just after the bottom of the crisis to the burst
            pointsPerIndex = (Info.MaxLevel / 2) / Double(Info.NumberOfTexturesBeforeBurst)
            index = Int(level / pointsPerIndex)
            if level == Info.TopBubbleLevel { index-- }
        } else { // From just after the burst to the bottom of the crisis
            pointsPerIndex = (Info.MaxLevel / 2) / Double(Info.NumberOfTexturesAfterBurst)
            index = Int((level - Info.MaxLevel / 2) / pointsPerIndex) + Info.NumberOfTexturesBeforeBurst
        }

        index = max(min(index, Info.NumberOfTexturesTotal-1), 0)
        return textureAtlas.textureNamed(Filename.texturePrefix + "\(index)")
    }
    

}