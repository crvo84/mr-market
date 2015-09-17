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
    static let GameOverSound = "failure.wav"
    static let SuccessSound = "success.wav"
    static let MoneySound = "money.wav"
    static let BackgroundMusicInitial = "hopping-along.mp3"
    static let BackgroundMusic = "ping-pong.mp3"
    static let AlertBackgroundMusic = "alertAlarm.mp3"
    static let PauseButton = "pause"
    static let MusicOn = "musicOn"
    static let MusicOff = "musicOff"
    static let Share = "share"
    static let Star = "star"
    static let Home = "home"
    static let RemoveAds = "removeAds"
    static let GrassTile = "grassTile"
    static let ScoreShare = "scoreShare"
    static let NextButton = "next"
    static let PreviousButton = "previous"
    static let ReloadButton = "reload"
    static let TouchScreen = "touchScreen"
    static let Controller = "controller"
}

struct Geometry {
    // mr market
    static let MrMarketRelativeWidth: CGFloat = 1.0 / 5.0 // Relative to scene width
    static let MrMarketAspectRatio: CGFloat = 290.0 / 450.0
    static let MrMarketLeftOffset: CGFloat = 10.0
    static let MrMarketUpperOffset: CGFloat = 10.0
    
    // block
    static let BlocksPerLine: CGFloat = 3.0
    static let BlocksPerColumn: CGFloat = 9.5
    static let BlockRelativeCornerRadius: CGFloat = 0.05 // Relative to block width
    static let BlockBorderWidth: CGFloat = 4.0
    // block item
    static let BlockItemRelativeHeight: CGFloat = 0.80 // Relative to block height
    // block text
    static let BlockTextRelativeHeight: CGFloat = 0.6 // relative to block height
    static let BlockTextRelativeWidth: CGFloat = 0.8 // of block width left after adding item image
    static let BlockTextYOffset: CGFloat = -1.0 // From to Y origin
    static let BlockHorizontalSeparation: CGFloat = 1.0 // Space between blocks
    
    
    // get cash counter
    static let GetCashCounterUpperOffset: CGFloat = 10
    
    // level label
    static let LevelLabelBackgroundOffset: CGFloat = 16.0
    static let LevelLabelRelativeCornerRadius: CGFloat = 0.03 // relative to background width
    static let LevelLabelBorderWidth: CGFloat = 0.0
    
    // pause button
    static let PauseButtonRightOffset: CGFloat = 6.0
    static let PauseButtonUpperOffset: CGFloat = 8.0
    static let PauseButtonMinimumSideSize: CGFloat = 32
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
    static let PauseNodeButtonRelativeCornerRadius: CGFloat = 0.03 // Relative to large button width
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
    static let GameOverNodeButtonRelativeCornerRadius: CGFloat = 0.03 // Relative to large button width
    // game over score labels
    static let GameOverNodeScoreLabelsVerticalSeparation: CGFloat = 12
    static let GameOverNodeBestLabelsVerticalSeparation: CGFloat = 8
    static let GameOverNodeScoreAndBestLabelsVerticalSeparation: CGFloat = 24
    
    // Button node
    static let ButtonNodeLabelRelativeWidth: CGFloat = 0.80 // relative to button width
    static let ButtonNodeLabelRelativeHeight: CGFloat = 0.50 // relative to button height
    
    // score label
    static let ScoreLabelUpperOffset: CGFloat = 10.0
    
    // floor
    static let FloorRelativeHeight: CGFloat = 1 / 10 // Relative to scene height
    
    // Tutorial
    static let TutorialExitButtonUpperOffset: CGFloat = 8
    static let TutorialExitButtonLeftOffset: CGFloat = 8
    static let TutorialExitButtonSideSize: CGFloat = 40
    static let TutorialReloadButtonUpperOffset: CGFloat = 8
    static let TutorialReloadButtonRightOffset: CGFloat = 8
    static let TutorialReloadButtonSideSize: CGFloat = 40
    static let TutorialLabelUpperOffset: CGFloat = 80
    static let TutorialTouchScreenVerticalOffsetFromCenter: CGFloat = -20
    static let TutorialMrMarketSizeMultiplierFactor: CGFloat = 2.0 // relative to normal game size
    static let TutorialMrMarketVerticalOffsetFromCenter: CGFloat = 16
    
    // Initial View
    static let InitialViewButtonRelativeCornerRadius: CGFloat = 0.03
}

struct Color {
//    static let MainBackground = SKColor(red: 0.0/255.0, green: 102.0/255.0, blue: 134.0/255.0, alpha: 1.0)
    static let MainBackground = SKColor(red: 0.0, green: 116/255, blue: 140/255, alpha: 1.0)
    
    // block
    static let BlockDefault = SKColor.whiteColor()
    static let BlockBorder = Color.MainBackground
    static let BlockTextDefault = SKColor(red: 0.0, green: 70/255, blue: 84/255, alpha: 1.0)
    static let BlockPurchased = SKColor.whiteColor()
    static let BlockMaxProfit: Double = 0.75 // positive value
    static let BlockMaxLoss: Double = -0.75 // negative value
    static let BlockMinValueForSecondaryColor: CGFloat = 0.30 // for red, green or blue
    static let BlockMaxValueForSecondaryColor: CGFloat = 0.75 // for red, green or blue
    
    // get cash label
    static let GetCashCounter =  SKColor(red: 1.0, green: 0.30, blue: 0.30, alpha: 1.0)
    static let GetCashLabel = Color.GetCashCounter
    
    // label background
    static let LabelBackground = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.60)
    static let LabelBackgroundBorder = SKColor.grayColor()
    
    // level label
    static let LevelLabel = SKColor.orangeColor()
    
    // score label
    static let ScoreLabelInitial = SKColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
    static let ScoreLabelProfit = SKColor(red: 0.50, green: 1.0, blue: 0.50, alpha: 1.0)
    static let ScoreLabelNotEnoughCash = SKColor(red: 1.0, green: 0.50, blue: 0.50, alpha: 1.0)
    
    // pause
    static let PausedLabel = SKColor.lightGrayColor()
    static let PauseNodeBackground = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.90)
    static let PauseNodeBorder = Color.PauseNodeBackground
    static let PauseNodeButton = SKColor.lightGrayColor()
    static let PauseNodeButtonBorder = Color.PauseNodeButton
    static let PauseNodeButtonText = SKColor.darkGrayColor()
    
    // game over
    static let GameOverNodeScoreLabel = SKColor.lightGrayColor()
    static let GameOverNodeBestScoreLabel = SKColor.lightGrayColor()
    static let GameOverNodeBackground = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.90)
    static let GameOverNodeBorder = Color.GameOverNodeBackground
    static let GameOverNodeLargeButton = SKColor.lightGrayColor()
    static let GameOverNodeSmallButton = SKColor.clearColor()
    static let GameOverNodeLargeButtonBorder = Color.GameOverNodeLargeButton
    static let GameOverNodeSmallButtonBorder = Color.GameOverNodeSmallButton
    static let GameOverNodeLargeButtonText = SKColor.darkGrayColor()
    static let GameOverNodeSmallButtonText = SKColor.darkGrayColor()
    
    // iAd
    static let AdBannerBackground = SKColor.clearColor()
    
    // tutorial
    static let TutorialBackground = Color.MainBackground
    static let TutorialMainTitle = SKColor.whiteColor()
    static let TutorialLabel = SKColor(red: 247/255, green: 169/255, blue: 59/255, alpha: 1.0)
    static let TutorialTouchScreenColorization = SKColor.whiteColor()
    static let TutorialTextView = SKColor.whiteColor()
    static let TutorialTextViewBackground = Color.MainBackground
}

struct FontSize {
    // block
    static let BlockPriceInitial: CGFloat = 10.0
    static let BlockLargestPriceText = "$99.9"
    // get cash
    static let GetCashCounterIphone: CGFloat = 35
    static let GetCashCounterIpad: CGFloat = 70
    static let GetCashLabelIphone: CGFloat = 32
    static let GetCashLabelIpad: CGFloat = 64
    // level label
    static let LevelLabelIphone: CGFloat = 40
    static let LevelLabelIpad: CGFloat = 80
    // score
    static let ScoreLabelIphone: CGFloat = 28
    static let ScoreLabelIpad: CGFloat = 56
    // pause
    static let PausedLabelIphone: CGFloat = 50
    static let PausedLabelIpad: CGFloat = 100
    // game over
    static let GameOverScoreLabelIphone: CGFloat = 34
    static let GameOverScoreLabelIpad: CGFloat = 68
    static let GameOverBestScoreLabelIphone: CGFloat = 24
    static let GameOverBestScoreLabelIpad: CGFloat = 48
    // tutorial
    static let TutorialMainTitleIphone: CGFloat = 40
    static let TutorialMainTitleIpad: CGFloat = 80
    static let TutorialLabelIphone: CGFloat = 44
    static let TutorialLabelIpad: CGFloat = 88
}

struct FontName {
    static let BlockText = "Arial"
    static let ScoreLabel = "Arial"
    static let PausedLabel = "Arial"
    static let PauseNodeButton = "Arial"
    static let GameOverScoreLabel = "Arial"
    static let GameOverButton = "Arial"
    static let GetCashCounter = "Arial"
    static let GetCashLabel = "Arial"
    static let LevelLabel = "Arial"
    static let TutorialMainTitle = "Arial"
    static let TutorialLabel = "Arial"
    static let TutorialTextView = "Arial"
}

struct Texture {
    static let blockImageNamePrefix = "blockImage"
    static let numberOfBlockImages = 17
}

struct Category {
    static let Block: UInt32 = 1
    static let Floor: UInt32 = 2
}

struct Time {
    // blocks
    static let BetweenBlocksForInitialSpeed: Double = 6.0   // Inside game must be divided by current physicsWorld speed and adjusted to device base height
    static let BetweenPeriodsForInitialSpeed: Double = 4.0 // Inside game must be divided by current physicsWorld speed and adjusted to device base height
    // Device Size. Time Between Blocks and Between Periods for initial speed is based on this device height. Adjust Time for different device heights.
    // To adjust: TimeForDeviceBaseHeight * CurrentDeviceHeight / DeviceBaseHeight
    static let DeviceBaseHeight: CGFloat = 667
    static let BlockExplosion = 1.0
    static let BlockShrink = 0.02
    // game over node
    static let GameOverNodePresentation = Time.BlockExplosion + 0.5
    static let GameOverNodeFadeIn = 0.3
    
    // get cash
    static let GetCashTotalCount: Double = 9 // seconds // 9
    static let GetCashLabelOnScreen: Double = 1
    static let GetCashLabelFadeInOut: Double = 0.2
    static let GetCashLabelTimesShowed: Int = Int(Time.GetCashTotalCount / ((Time.GetCashLabelOnScreen + Time.GetCashLabelFadeInOut) * 2)) // label animation cannot last more than counter
    
    // level label
    static let LevelLabelFadeInOut: Double = 0.6
    static let LevelLabelOnScreen: Double = 1.5
    
    // tutorial
    static let TutorialLabelFadeInOut: Double = 1.0
    static let TutorialWaitBetweenActions: Double = 1.5
    static let TutorialTouchScreenFadeInOut: Double = 0.8
    static let TutorialTouchScreenHighlight: Double = 0.5
    static let TutorialMrMarketMoodFaceChange: Double = 1.2
    static let TutorialSentenceBetweenLabels: Double = 5.0
    static let TutorialSentenceFadeInOut: Double = 0.6
}

struct Physics {
    static let Gravity: CGFloat = -0.5
    static let BlockLinearDamping: CGFloat = 1.0
    static let BlockMass: CGFloat = 5.0
    static let BlockRestitution: CGFloat = 0.0
}

struct ZPosition {
    static let MrMarket: CGFloat = 3
    static let ScoreLabel: CGFloat = 3
    static let Block: CGFloat = 4
    static let Floor: CGFloat = 5
    static let Button: CGFloat = 5
    static let Explosion: CGFloat = 6
    static let GetCashCounter: CGFloat = 7
    static let GetCashLabel: CGFloat = 7
    static let LevelLabel: CGFloat = 8
    static let TutorialLabel: CGFloat = 8
    static let TutorialMainTitle: CGFloat = 8
    static let PauseNode: CGFloat = 9
    static let GameOverNode: CGFloat = 9
    static let TouchScreen: CGFloat = 9
}

struct Shake {
    static let Key = "shakeKey"
    static let Movements: Int = 15 // Number of individual movements
    static let Distance: Double = 20.0 // How big
    static let Duration: Double = 0.25 // How long
}

struct ActionKey {
    static let GetCashLabel = "GetCashLabel"
    static let GetCashCounter = "GetCashCounter"
}

struct CompanyInfo {
    static let MaxBeta: Double = 1.0 // 1
    static let MinBeta: Double = 1.0 // 1
    static let BetaMaxPercentDeviation: UInt32 = 50 // +/- 0% to 50% // 50
    static let MaxInitialPriceInteger: UInt32 = 1 // 1
    static let MinInitialPriceInteger: UInt32 = 1 // 1
    static let MaxDecimals: Int = 1
}

struct GameOption {
    // game level
    static let GameLevelsPerUILevelInitial: Int = 5 // 5
    static let GameLevelsPerUILevelIncrease: Int = 5 // increased every UI level // 5
    static let UILevelBonusInitial: Double = 50
    static let UILevelBonusIncrease: Double = 100

    // period variables
    static let PeriodsInitial: Int = 1 // 1
    static let PeriodsIncrease: Int = 0 // 0
    static let PeriodsMax: Int = 1 // 1
    static let NumberOfCompaniesInitial: Int = 2 // 2
    static let NumberOfCompaniesIncrease: Int = 1 // 1
    static let NumberOfCompaniesMax: Int = 5 // <= 0 for no maximum // 5
    static let SpeedInitial: CGFloat = 10 // 0.70
    static let SpeedIncrease: CGFloat = 0.08 // 0.08
    static let TransactionAmountInitial: Double = 100.0 // 100
    static let TransactionAmountIncrease: Double = 0.0 // 0
    // initial setup
    static let InitialCash: Double = 500000.0 // 500
    static let InitialMarketLevel: Int = 0 // 0
    // profit/loss
    static let UpdateAllPricesSimultaneously: Bool = true // true
    static let GameOverRecoverOriginalInvestments: Bool = false
}

struct MarketOption {
    static let ProbabilityOfBreakingTrend: Double = 0.25 // 0.25
    static let MaxPercentReturn: Double = 20 // 20
    static let MinPercentReturn: Double = 20 // 20
    static let BurstReturnFactor: Double = 0.85 // 0.85
}

struct Tutorial {
    static let Speed: CGFloat = 1.5
    static let TouchScreenInitialAlpha: CGFloat = 0.3
    static let TouchScreenFinalAlpha: CGFloat = 0.8
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
    static let ReloadButton = "reloadButton"
    static let NextButton = "nextButton"
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
    static let MrMarket = "Mr. Market"
    static let Level = NSLocalizedString("Level", comment: "Noun. e.g. 'Level 2'")
    static let Paused = NSLocalizedString("Paused", comment: "Used for a label showed when the game is paused")
    static let Continue = NSLocalizedString("Continue", comment: "For a button. To continue playing a game")
    static let Restart = NSLocalizedString("Restart", comment: "For a button. To restart the game")
    static let Quit = NSLocalizedString("Quit", comment: "For a button. To quit a game")
    static let Score = NSLocalizedString("Score", comment: "Noun. For a label to show the score. e.g. 'Score: 123'")
    static let Best = NSLocalizedString("Best", comment: "For a label to show the best score. 'Best: 456'")
    static let TryAgain = NSLocalizedString("Try again", comment: "For a button, to play again and try to get a better score")
    static let RemoveAds = NSLocalizedString("Remove Ads", comment: "For a button, to pay to remove advertising.")
    static let Purchase = NSLocalizedString("Purchase", comment: "Verb. For a button, to purchase a product")
    static let Buy = NSLocalizedString("Buy", comment: "e.g. 'Buy stock'")
    static let Sell = NSLocalizedString("Sell", comment: "e.g. 'Sell stock'")
    static let RejectOffer = NSLocalizedString("Reject offer", comment: "To reject an offer to buy stock.")
    static let Restore = NSLocalizedString("Restore", comment: "Verb. For a button to restore previous purchases.")
    static let Cancel = NSLocalizedString("Cancel", comment: "Verb. For a button to cancel an operation")
    static let Ok = NSLocalizedString("Ok", comment: "For a button to close an alert view.")
    static let GetCash = NSLocalizedString("Low cash!", comment: "For an alert label, to let the user know that she/he needs to get more cash.")
    static let NoPreviousPurchases = NSLocalizedString("No previous purchases could be restored.", comment: "For an alert view message.")
    static let PurchasesRestored = NSLocalizedString("Purchases restored successfully.", comment: "For an alert view message.")
    static let CanYouBeatMe = NSLocalizedString("Can you beat me?", comment: "To send to a friend when you want to challenge him to beat your score.")
    static let HowToPlay = NSLocalizedString("How to play", comment: "The title for a game tutorial. NOT a question.")
    // tutorial
    static let TutorialSentence0 = NSLocalizedString("This is Mr. Market.",
        comment: "To introduce a person named 'Mr. Market'. The name 'Mr. Market' should not be translated, it is a name.")
    static let TutorialSentence1 = NSLocalizedString("Is he bipolar? You bet he is.",
        comment: "First asks if he is bipolar. Then answers the question that you can be sure he is.")
    static let TutorialSentence2 = NSLocalizedString("But despite of his obvious mood disorder, millions of people follow his lead.",
        comment: "Its a continuation of the sentence: 'Is he bipolar? you bet he is'...")
    static let TutorialSentence3 = NSLocalizedString("Think for yourself! But don't ignore him, instead, do business with him.",
        comment: "The first sentence is an exclamation (hence the exclamation mark) 'Think for yourself!")
    static let TutorialSentence4 = NSLocalizedString("He provides you with prices. You decide whether or not to accept them.",
        comment: "Referring to stock prices.")
    static let TutorialSentence5 = NSLocalizedString("'Be fearful when others are greedy and greedy when others are fearful.' -Warren Buffett",
        comment: "Quote. The name of the author is 'Warren Buffett'")
    static let Assumptions = NSLocalizedString("Assumptions",
        comment: "Noun. Plural. Something taken for granted. e.g. 'Assumptions: 1)... 2)...")
    static let Assumption0 = NSLocalizedString("All prices in the game belong to companies with good performance.",
        comment: "It is referring to prices for company stock (shares). From stock market. Good performance, is refering to companies that have enough profit.")
    static let Assumption1 = NSLocalizedString("Amount of each purchase",
        comment: "e.g. 'Amount of each purchase: $100'")
}

struct URLString {
    static let AppStoreDownload = "http://itunes.apple.com/app/id1033738154"
    static let AppStoreRate = "itms-apps://itunes.apple.com/app/id1033738154"
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
    static let QuitTutorial = "Quit Tutorial"
    static let HowToPlay = "How To Play"
    static let QuitHowToPlay = "Quit How To Play"
    static let WhoIsMrMarket = "Who Is Mr Market"
    static let QuitWhoIsMrMarket = "Quit Who Is Mr Market"
    static let BookReference = "Book Reference"
}

struct StoryboardId {
    static let TutorialPageContentViewController = "TutorialPageContentViewController"
    static let TutorialPageViewController = "TutorialPageViewController"
}

struct GameCenter {
    static let LeaderboardId = "Mr_Market_001"
}

struct InAppPurchase {
    static let RemoveAdsProductId = "MrMarketRemoveAds"
}

struct Volume {
    static let AlertBackgroundMusic: Float = 0.2
}









