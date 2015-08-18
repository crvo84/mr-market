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
    static let SparkEmitter = "SparkParticle.sks"
    static let PopSound = "pop.wav"
    static let SlamSound = "slam.wav"
    static let BackgroundMusic = "Two Finger Johnny.mp3"
}

struct Geometry {
    // mr market
    static let MrMarketRelativeWidth: CGFloat = 1.0 / 6.0 // Relative to scene width
    static let MrMarketAspectRatio: CGFloat = 290.0 / 450.0
    static let MrMarketLeftOffset: CGFloat = 15.0
    static let MrMarketTopOffset: CGFloat = 15.0
    
    // block
    static let BlockItemRelativeHeight: CGFloat = 0.8 // Relative to block height
    static let BlockRelativeCornerRadius: CGFloat = 0.05 // Relative to block width
    static let BlocksPerLine: CGFloat = 3.0
    static let BlocksPerColumn: CGFloat = 11.5
    static let BlockRelativeHeight: CGFloat = 0.45 // Relative to block width
    static let BlockBorderWidth: CGFloat = 4.0
    static let BlockTextLeftOffset: CGFloat = 4.0 // From item node
    static let BlockTextVerticalOffset: CGFloat = -1.0 // From to Y origin
    static let BlockHorizontalSeparation: CGFloat = 1.0 // Space between blocks
}

struct Color {
    static let MainBackground = SKColor(red: 0.0/255.0, green: 64.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    static let BlockDefault = SKColor.whiteColor()
    static let BlockBorder = Color.MainBackground
    static let BlockTextDefault = SKColor.blackColor()
    static let BlockPurchased = SKColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.0)
}

struct FontSize {
    static let BlockTextIphone: CGFloat = 15
    static let BlockTextIpad: CGFloat = 30
}

struct Texture {
    static let blockImageNamePrefix = "blockImage"
    static let numberOfBlockImages = 11
}

struct Category {
    static let Block: UInt32 = 1
    static let Floor: UInt32 = 2
}

struct Time {
    static let BetweenBlocks = 2.0 / Double(GameOptions.Speed)
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


struct Shake {
    static let Key = "shakeKey"
    static let Movements: Int = 15 // Number of individual movements
    static let Distance: Double = 20.0 // How big
    static let Duration: Double = 0.25 // How long
}

struct CompanyInfo {
    static let MaxBeta: Double = 10.0
    static let MinBeta: Double = 0.5
    static let BetaMaxPercentDeviation: UInt32 = 50 // +/- 0% to 50%
    static let MaxInitialPriceInteger: UInt32 = 25
    static let MinInitialPriceInteger: UInt32 = 1
    static let MaxDecimals: Int = 1
//    static let TransactionAmount: Double = 100.0
}

struct GameOptions {
    static let Periods: Int = 5
    static let NumberOfCompanies: Int = 2
    static let Speed: CGFloat = 1.0
    static let MarketVolatility: Double = 1.0
}

struct MarketOptions {
    static let ProbabilityOfBreakingTrend: Double = 0.10
    static let LevelIncrease: Double = 2.0 // can be how many level units to change mr market face
    static let FasterLevelBurstFactor: Double = 2.0
    static let MaxPercentReturn: UInt32 = 3
}















