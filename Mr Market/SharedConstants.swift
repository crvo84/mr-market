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
    static let PauseButton = "pause"
    static let MusicOn = "musicOn"
    static let MusicOff = "musicOff"
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
    
    // pause button
    static let PauseButtonRightOffset: CGFloat = 10.0
    static let PauseButtonUpperOffset: CGFloat = 10.0
    // pause node
    static let PauseNodeRelativeHeight: CGFloat = 0.8 // Relative to scene height
    static let PauseNodeRelativeWidth: CGFloat = 0.8 // Relative to scene width
    static let PauseNodeRelativeCornerRadius: CGFloat = 0.05 // Relative to pause node width
    static let PauseNodeBorderWidth: CGFloat = 0.0
    // pause node buttons
    static let PauseNodeLargeButtonRelativeWidth: CGFloat = 0.80
    static let PauseNodeButtonRelativeHeight: CGFloat = 1/8
    static let PauseNodeSmallButtonHorizontalSeparation: CGFloat = 8
    static let PauseNodeButtonVerticalSeparation: CGFloat = 8
    static let PauseNodeMusicOnOffButtonOffset: CGFloat = 10
    static let PauseNodeButtonBorderWidth: CGFloat = 0.0
    static let PauseNodeButtonRelativeCorderRadius: CGFloat = 0.0 // Relative to large button width
    // paused label
    static let PausedLabelUpperOffset: CGFloat = 15.0
    // score label
    static let ScoreLabelUpperOffset: CGFloat = 10.0
}

struct Color {
    static let MainBackground = SKColor(red: 0.0/255.0, green: 64.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    // block
    static let BlockDefault = SKColor.whiteColor()
    static let BlockBorder = Color.MainBackground
    static let BlockTextDefault = SKColor.blackColor()
    static let BlockPurchased = SKColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.0)
    // score label
    static let ScoreLabel = SKColor.lightGrayColor()
    // level label
    static let LevelLabel = SKColor.lightGrayColor()
    // pause
    static let PausedLabel = SKColor.lightGrayColor()
    static let PauseNodeBackground = SKColor.darkGrayColor()
    static let PauseNodeBorder = Color.PauseNodeBackground
    static let PauseNodeButton = SKColor.lightGrayColor()
    static let PauseNodeButtonBorder = Color.PauseNodeButton
    static let PauseNodeButtonText = SKColor.darkGrayColor()
}

struct FontSize {
    // block
    static let BlockTextIphone: CGFloat = 15
    static let BlockTextIpad: CGFloat = 30
    // score
    static let ScoreLabelIphone: CGFloat = 20
    static let ScoreLabelIpad: CGFloat = 40
    // pause
    static let PausedLabelIphone: CGFloat = 40
    static let PausedLabelIpad: CGFloat = 80
    static let PauseNodeLargeButtonIphone: CGFloat = 40
    static let PauseNodeLargeButtonIpad: CGFloat = 20
    static let PauseNodeSmallButtonIphone: CGFloat = 30
    static let PauseNodeSmallButtonIpad: CGFloat = 15
    // level
    static let LevelLabelIphone: CGFloat = 40
    static let LevelLabelIpad: CGFloat = 80
}

struct FontName {
    static let BlockText = "Arial"
    static let ScoreLabel = "Arial"
    static let PausedLabel = "Arial"
    static let PauseNodeButtons = "Arial"
    static let LevelLabel = "Arial"
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
    static let BetweenBlocks = 3.0 / Double(GameOption.Speed) // TODO: update gamespeed on each level?
    static let BetweenPeriods = Time.BetweenBlocks * 2
    static let BlockColorization = 1.0
    static let BlockExplosion = 1.0
    static let BlockShrink = 0.02
    static let LevelLabelOnScreen = 2.0
    static let LevelLabelFadeOut = 0.6
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
    static let ScoreLabel: CGFloat = 5
    static let PauseButton: CGFloat = 5
    static let PausedLabel: CGFloat = 6
    static let LevelLabel: CGFloat = 6
    static let Block: CGFloat = 4
    static let pauseNode: CGFloat = 7
}


struct Shake {
    static let Key = "shakeKey"
    static let Movements: Int = 15 // Number of individual movements
    static let Distance: Double = 20.0 // How big
    static let Duration: Double = 0.25 // How long
}

struct CompanyInfo {
    static let MaxBeta: Double = 2
    static let MinBeta: Double = 0.5
    static let BetaMaxPercentDeviation: UInt32 = 50 // +/- 0% to 50%
    static let MaxInitialPriceInteger: UInt32 = 25
    static let MinInitialPriceInteger: UInt32 = 1
    static let MaxDecimals: Int = 1
}

struct GameOption {
    static let Periods: Int = 2 // min 16 for complete market cycle
    static let PeriodsIncrease: Int = 1
    static let MaxPeriods: Int = 20
    static let NumberOfCompanies: Int = 2
    static let NumberOfCompaniesIncrease: Int = 1
    static let Speed: CGFloat = 1.0
    static let SpeedIncrease: CGFloat = 0.2
    static let MusicRateIncrease: Float = 0
    static let TransactionAmount: Double = 1000000.0
    static let InitialMarketLevel: Int = 0
    static let InitialMarketLevelIncrease: Int = 2
}

struct MarketOption {
    static let ProbabilityOfBreakingTrend: Double = 0.0
    static let MaxPercentReturn: Double = 5
    static let MinPercentReturn: Double = 5
    static let BurstReturnFactor: Double = 1.5
}

struct NodeName {
    static let MrMarket = "mrMarketNode"
    static let PauseButton = "pauseButton"
    static let ContinueButton = "continueButton"
    static let RestartButton = "restartButton"
    static let QuitButton = "quitButton"
}

struct UserDefaultsKey {
    static let musicOn = "musicOn"
}

struct UserDefaults {
    static let musicOn = true
}


struct Text {
    static let Level = "Level"
    static let Paused = "Paused"
    static let Continue = "Continue"
    static let Restart = "Restart"
    static let Quit = "Quit"
    static let Score = "Score"
    static let Best = "Best"
    static let TryAgain = "Try again"
}

struct SegueId {
    static let StartGame = "Start Game"
    static let QuitGame = "Quit Game"
}




