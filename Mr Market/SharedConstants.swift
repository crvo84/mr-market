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
    static let BackgroundMusicInitial = "hopping-along.mp3"
    static let BackgroundMusic = "ping-pong.mp3"
    static let PauseButton = "pause"
    static let MusicOn = "musicOn"
    static let MusicOff = "musicOff"
    static let Share = "share"
    static let Star = "star"
    static let Home = "home"
    static let RemoveAds = "removeAds"
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
    static let PauseNodeRelativeHeight: CGFloat = 1.0 // Relative to scene height
    static let PauseNodeRelativeWidth: CGFloat = 1.0 // Relative to scene width
    static let PauseNodeRelativeCornerRadius: CGFloat = 0.0 // Relative to pause node width
    static let PauseNodeBorderWidth: CGFloat = 0.0
    // pause node buttons
    static let PauseNodeLargeButtonRelativeWidth: CGFloat = 0.80 // Relative to pause node width
    static let PauseNodeButtonRelativeHeight: CGFloat = 1/8 // Relative to pause node height
    static let PauseNodeSmallButtonHorizontalSeparation: CGFloat = 8
    static let PauseNodeButtonVerticalSeparation: CGFloat = 8
    static let PauseNodeMusicOnOffButtonOffset: CGFloat = 10
    static let PauseNodeButtonBorderWidth: CGFloat = 0.0
    static let PauseNodeButtonRelativeCornerRadius: CGFloat = 0.0 // Relative to large button width
    // paused music on/off node
    static let PausedMusicOnOffNodeLeftOffset: CGFloat = 16.0
    static let PausedMusicOnOffNodeLowerOffset: CGFloat = 8.0
    
    // game over node
    static let GameOverNodeRelativeHeight: CGFloat = 1.0 // Relative to scene height
    static let GameOverNodeRelativeWidth: CGFloat = 1.0 // Relative to scene width
    static let GameOverNodeRelativeCornerRadius: CGFloat = 0.00 // Relative to gameOver node width
    static let GameOverNodeBorderWidth: CGFloat = 0.0
    // game over node buttons
    static let GameOverNodeLargeButtonRelativeWidth: CGFloat = 0.80 // Relative to gameOver node width
    static let GameOverNodeLargeButtonRelativeHeight: CGFloat = 1/8 // Relative to gameOver node heigh
    static let GameOverNodeSmallButtonHorizontalSeparation: CGFloat = 16
    static let GameOverNodeSmallButtonImageRelativeWidth: CGFloat = 0.90 // Relative to button background
    static let GameOverNodeButtonVerticalSeparation: CGFloat = 24
    static let GameOverNodeButtonBorderWidth: CGFloat = 0.0
    static let GameOverNodeButtonRelativeCornerRadius: CGFloat = 0.00 // Relative to large button width
    // game over score labels
    static let GameOverNodeScoreLabelsVerticalSeparation: CGFloat = 16
    
    // score label
    static let ScoreLabelUpperOffset: CGFloat = 10.0
    
    // hi invest button
    static let HiInvestButtonRelativeCornerRadius: CGFloat = 0.1 // Relative to button width
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
    static let PauseNodeBackground = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
    static let PauseNodeBorder = Color.PauseNodeBackground
    static let PauseNodeButton = SKColor.lightGrayColor()
    static let PauseNodeButtonBorder = Color.PauseNodeButton
    static let PauseNodeButtonText = SKColor.darkGrayColor()
    // game over
    static let GameOverNodeScoreLabel = SKColor.lightGrayColor()
    static let GameOverNodeBestScoreLabel = SKColor.lightGrayColor()
    static let GameOverNodeBackground = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.85)
    static let GameOverNodeBorder = Color.GameOverNodeBackground
    static let GameOverNodeLargeButton = SKColor.lightGrayColor()
    static let GameOverNodeSmallButton = SKColor.clearColor()
    static let GameOverNodeLargeButtonBorder = Color.GameOverNodeLargeButton
    static let GameOverNodeSmallButtonBorder = Color.GameOverNodeSmallButton
    static let GameOverNodeLargeButtonText = SKColor.darkGrayColor()
    static let GameOverNodeSmallButtonText = SKColor.darkGrayColor()
    
    // iAd
    static let AdBannerBackground = SKColor(red: 0.0/255.0, green: 32.0/255.0, blue: 48.0/255.0, alpha: 1.0)
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
    static let PauseNodeLargeButtonIphone: CGFloat = 30
    static let PauseNodeLargeButtonIpad: CGFloat = 50
    static let PauseNodeSmallButtonIphone: CGFloat = 25
    static let PauseNodeSmallButtonIpad: CGFloat = 40
    // game over
    static let GameOverScoreLabelIphone: CGFloat = 30
    static let GameOverScoreLabelIpad: CGFloat = 50
    static let GameOverBestScoreLabelIphone: CGFloat = 20
    static let GameOverBestScoreLabelIpad: CGFloat = 40
    static let GameOverNodeLargeButtonIphone: CGFloat = 30
    static let GameOverNodeLargeButtonIpad: CGFloat = 50
    static let GameOverNodeSmallButtonIphone: CGFloat = 18
    static let GameOverNodeSmallButtonIpad: CGFloat = 30
    
    // level
    static let LevelLabelIphone: CGFloat = 40
    static let LevelLabelIpad: CGFloat = 80
}

struct FontName {
    static let BlockText = "Arial"
    static let ScoreLabel = "Arial"
    static let PausedLabel = "Arial"
    static let PauseNodeButton = "Arial"
    static let GameOverScoreLabel = "Arial"
    static let GameOverButton = "Arial"
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
    static let BetweenBlocksForInitialSpeed: Double = 4.0   // Inside game must be divided by current physicsWorld speed
    static let BetweenPeriodsForInitialSpeed: Double = 5.0 // Inside game must be divided by current physicsWorld speed
    static let BlockColorization = 1.0
    static let BlockExplosion = 1.0
    static let BlockShrink = 0.02
    static let LevelLabelOnScreen = 2.0
    static let LevelLabelFadeOut = 0.6
    static let GameOverNodePresentation = Time.BlockExplosion + 0.5
    static let GameOverNodeFadeIn = 0.3
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
    static let PauseNode: CGFloat = 7
    static let GameOverNode: CGFloat = 7
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
    static let MaxInitialPriceInteger: UInt32 = 9
    static let MinInitialPriceInteger: UInt32 = 1
    static let MaxDecimals: Int = 1
}

struct GameOption {
    static let PeriodsInitial: Int = 3 // 8 for complete market cycle // 3
    static let PeriodsIncrease: Int = 1 // 1
    static let PeriodsMax: Int = 16 // 16
    static let NumberOfCompaniesInitial: Int = 1 // 1
    static let NumberOfCompaniesIncrease: Int = 1 // 1
    static let SpeedInitial: CGFloat = 0.8 // 0.8
    static let SpeedIncrease: CGFloat = 0.1 // 0.1
    static let TransactionAmountInitial: Double = 10.0
    static let TransactionAmountIncrease: Double = 5.0
    static let InitialMarketLevel: Int = 0
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
    static let MusicOnOff = "musicOnOff"
    static let ShareButton = "shareButton"
    static let RateButton = "rateButton"
    static let RemoveAdsButton = "removeAdsButton"
}

struct UserDefaultsKey {
    static let MusicOn = "musicOn"
    static let BestScore = "bestScore"
    static let ShowAds = "showAds"
}

struct UserDefaults {
    static let MusicOn = true
    static let BestScore: Double = 0.0
    static let ShowAds = true
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
    static let RemoveAds = "Remove Ads"
    static let Purchase = "Purchase"
    static let Restore = "Restore"
    static let Cancel = "Cancel"
    static let Ok = "Ok"
    static let Error = "Error"
    static let NoPreviousPurchases = "No previous purchases could be restored."
    static let PurchasesRestored = "Purchases restored successfully."

}

struct URLString {
    static let AppStoreDownload = "http://itunes.apple.com/app/id1009148607"
    static let AppStoreRate = "itms-apps://itunes.apple.com/app/id1009148607"
    static let FacebookFromApp = "fb://profile/800203350077160"
    static let Facebook = "https://www.facebook.com/800203350077160"
    static let TwitterFromApp = "twitter:///user?screen_name=Villou_Apps"
    static let Twitter = "https://twitter.com/Villou_Apps"
    static let Villou = "http://www.villou.com"
}

struct SegueId {
    static let InitialScreen = "Initial Screen"
    static let StartGame = "Start Game"
    static let QuitGame = "Quit Game"
    static let RemoveAds = "Remove Ads"
}

struct GameCenter {
    static let LeaderboardId = "Mr_Market_001"
}

struct InAppPurchase {
    static let RemoveAdsProductId = "MrMarketRemoveAds"
}











