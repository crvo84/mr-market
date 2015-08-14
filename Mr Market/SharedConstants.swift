//
//  SharedConstants.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

struct Filename {
    static let SpritesAtlas = "sprites.atlas"
    static let SparkEmitter = "ExplosionParticle.sks"
}

struct Geometry {
    // mr market
    static let MrMarketRelativeWidth: CGFloat = 1.0 / 6.0 // Relative to scene width
    static let MrMarketAspectRatio: CGFloat = 290.0 / 450.0
    static let MrMarketLeftOffset: CGFloat = 15.0
    static let MrMarketTopOffset: CGFloat = 15.0
    
    // block
    static let BlockItemRelativeHeight: CGFloat = 0.8 // Relative to block height
    static let BlockRelativeCornerRadius: CGFloat = 0.15 // Relative to block width
    static let BlocksPerLine: CGFloat = 3.0
    static let BlockRelativeHeight: CGFloat = 0.45 // Relative to block width
    static let BlockBorderWidth: CGFloat = 0.0
    static let BlockTextLeftOffset: CGFloat = 4.0 // From item node
    static let BlockTextVerticalOffset: CGFloat = -1.0 // From to Y origin
    static let BlockHorizontalSeparation: CGFloat = 4.0 // Space between blocks
}

struct Color {
    static let MainBackground = SKColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
    static let BlockDefault = SKColor.whiteColor()
    static let BlockTextDefault = SKColor.blackColor()
    static let BlockPurchased = SKColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    static let BlockSmoke = SKColor.lightGrayColor()
}

struct FontSize {
    static let BlockTextIphone: CGFloat = 15
    static let BlockTextIpad: CGFloat = 30
}

struct Texture {
    static let blockItemNamePrefix = "blockItem"
    static let numberOfBlockItems: UInt32 = 11
}

struct Category {
    static let Block: UInt32 = 1
    static let Floor: UInt32 = 2
}

struct Time {
    static let BetweenBlocks = 0.5
    static let BlockColorization = 1.0
    static let BlockExplosion = 1.0
    static let BlockShrink = 0.02
}

struct Physics {
    static let Gravity: CGFloat = -0.5
    static let BlockLinearDamping: CGFloat = 1.0
    static let BlockMass: CGFloat = 5.0
    static let BlockRestitution: CGFloat = 0.0
}

struct ZPosition {
    static let Exposion: CGFloat = 6
    static let MrMarket: CGFloat = 5
    static let Block: CGFloat = 4
}

struct Price {
    static let MaxInitialInteger: UInt32 = 25
    static let MaxDecimals: Int = 1
}







