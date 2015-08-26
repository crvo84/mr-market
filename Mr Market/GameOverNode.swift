//
//  GameOverNode.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class GameOverNode: SKSpriteNode {
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    private var backgroundNode: SKShapeNode?
    // score labels
    private var scoreLabel: SKLabelNode?
    private var bestScoreLabel: SKLabelNode?
    // large button
    private var tryAgainButton: ButtonNode?
    // small buttons
    private var shareButton: ButtonNode?
    private var rateButton: ButtonNode?
    private var removeAdsButton: ButtonNode?
    private var quitButton: ButtonNode?
    // music on/off button
    private var musicOnOffButton: SKSpriteNode?

    init(size: CGSize, score: String, bestScore: String, musicOn: Bool) {
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        // BACKGROUND
        let backgroundSize = CGSize(width: size.width * Geometry.PauseNodeRelativeWidth, height: size.height * Geometry.PauseNodeRelativeHeight)
        let backgroundCornerRadius = Geometry.PauseNodeRelativeCornerRadius * backgroundSize.width
        backgroundNode = SKShapeNode(rectOfSize: backgroundSize, cornerRadius: backgroundCornerRadius)
        backgroundNode!.fillColor = Color.PauseNodeBackground
        backgroundNode!.lineWidth = Geometry.PauseNodeBorderWidth
        backgroundNode!.strokeColor = Color.PauseNodeBorder
        addChild(backgroundNode!)
        
        // TRY AGAIN BUTTON
        let tryAgainButtonSize = CGSize(width: size.width * Geometry.GameOverNodeLargeButtonRelativeWidth, height: size.height * Geometry.GameOverNodeLargeButtonRelativeHeight)
        let tryAgainButtonCornerRadius = Geometry.GameOverNodeButtonRelativeCornerRadius * tryAgainButtonSize.width
        tryAgainButton = ButtonNode(size: tryAgainButtonSize, cornerRadius: tryAgainButtonCornerRadius, labelText: Text.TryAgain, imageTexture: nil)
        tryAgainButton!.backgroundColor = Color.GameOverNodeLargeButton
        tryAgainButton!.borderWidth = Geometry.GameOverNodeButtonBorderWidth
        tryAgainButton!.borderColor = Color.GameOverNodeBorder
        tryAgainButton!.position = CGPoint(x: 0.0, y: 0.0)
        tryAgainButton!.labelFontName = FontName.GameOverButton
        tryAgainButton!.labelFontSize = isIpad ? FontSize.GameOverNodeLargeButtonIpad : FontSize.GameOverNodeLargeButtonIphone
        tryAgainButton!.labelFontColor = Color.GameOverNodeLargeButtonText
        tryAgainButton!.name = NodeName.RestartButton
        backgroundNode!.addChild(tryAgainButton!)
        
        // SMALL BUTTONS
        let smallButtonsNum: CGFloat = 4.0
        let smallButtonSide = (tryAgainButton!.size.width - Geometry.GameOverNodeSmallButtonHorizontalSeparation * (smallButtonsNum - 1)) / smallButtonsNum
        let smallButtonSize = CGSize(width: smallButtonSide, height: smallButtonSide)
        let smallButtonY = tryAgainButton!.position.y - tryAgainButton!.size.height / 2.0 - Geometry.GameOverNodeButtonVerticalSeparation - smallButtonSize.height / 2.0
        // share
        shareButton = ButtonNode(size: smallButtonSize, cornerRadius: tryAgainButtonCornerRadius, labelText: nil, imageTexture: SKTexture(imageNamed: Filename.Share))
        shareButton!.backgroundColor = Color.GameOverNodeSmallButton
        shareButton!.borderWidth = Geometry.GameOverNodeBorderWidth
        shareButton!.borderColor = Color.GameOverNodeBorder
        shareButton!.position = CGPoint(x: -(smallButtonSize.width + Geometry.GameOverNodeSmallButtonHorizontalSeparation) * 1.5, y: smallButtonY)
        shareButton!.name = NodeName.ShareButton
        backgroundNode!.addChild(shareButton!)
        // rate
        rateButton = ButtonNode(size: smallButtonSize, cornerRadius: tryAgainButtonCornerRadius, labelText: nil, imageTexture: SKTexture(imageNamed: Filename.Star))
        rateButton!.backgroundColor = Color.GameOverNodeSmallButton
        rateButton!.borderWidth = Geometry.GameOverNodeBorderWidth
        rateButton!.borderColor = Color.GameOverNodeBorder
        rateButton!.position = CGPoint(x: -(smallButtonSize.width + Geometry.GameOverNodeSmallButtonHorizontalSeparation) * 0.5, y: smallButtonY)
        rateButton!.name = NodeName.RateButton
        backgroundNode!.addChild(rateButton!)
        // remove ads
        removeAdsButton = ButtonNode(size: smallButtonSize, cornerRadius: tryAgainButtonCornerRadius, labelText: nil, imageTexture: SKTexture(imageNamed: Filename.RemoveAds))
        removeAdsButton!.backgroundColor = Color.GameOverNodeSmallButton
        removeAdsButton!.borderWidth = Geometry.GameOverNodeBorderWidth
        removeAdsButton!.borderColor = Color.GameOverNodeBorder
        removeAdsButton!.position = CGPoint(x: +(smallButtonSize.width + Geometry.GameOverNodeSmallButtonHorizontalSeparation) * 0.5, y: smallButtonY)
        removeAdsButton!.name = NodeName.RemoveAdsButton
        backgroundNode!.addChild(removeAdsButton!)
        // quit
        quitButton = ButtonNode(size: smallButtonSize, cornerRadius: tryAgainButtonCornerRadius, labelText: nil, imageTexture: SKTexture(imageNamed: Filename.Home))
        quitButton!.backgroundColor = Color.GameOverNodeSmallButton
        quitButton!.borderWidth = Geometry.GameOverNodeBorderWidth
        quitButton!.borderColor = Color.GameOverNodeBorder
        quitButton!.position = CGPoint(x: +(smallButtonSize.width + Geometry.GameOverNodeSmallButtonHorizontalSeparation) * 1.5, y: smallButtonY)
        quitButton!.name = NodeName.QuitButton
        backgroundNode!.addChild(quitButton!)
        
        let labelsMiddlePointY = size.height / 4.0 + tryAgainButton!.size.height / 2.0
        // SCORE LABEL
        scoreLabel = SKLabelNode(text: Text.Score + ": " + score)
        scoreLabel!.fontColor = Color.GameOverNodeScoreLabel
        scoreLabel!.fontSize = isIpad ? FontSize.GameOverScoreLabelIpad : FontSize.GameOverScoreLabelIphone
        scoreLabel!.fontName = FontName.GameOverScoreLabel
        scoreLabel!.verticalAlignmentMode = .Bottom
        scoreLabel!.horizontalAlignmentMode = .Center
        scoreLabel!.position = CGPoint(x: 0.0, y: labelsMiddlePointY + Geometry.GameOverNodeScoreLabelsVerticalSeparation / 2.0)
        backgroundNode!.addChild(scoreLabel!)
        // BEST SCORE LABEL
        bestScoreLabel = SKLabelNode(text: Text.Best + ": " + bestScore)
        bestScoreLabel!.fontColor = Color.GameOverNodeBestScoreLabel
        bestScoreLabel!.fontSize = isIpad ? FontSize.GameOverBestScoreLabelIpad : FontSize.GameOverBestScoreLabelIphone
        bestScoreLabel!.fontName = FontName.GameOverScoreLabel
        bestScoreLabel!.verticalAlignmentMode = .Top
        bestScoreLabel!.horizontalAlignmentMode = .Center
        bestScoreLabel!.position = CGPoint(x: 0.0, y: labelsMiddlePointY - Geometry.GameOverNodeScoreLabelsVerticalSeparation)
        backgroundNode!.addChild(bestScoreLabel!)
        
//        // MUSIC ON/OFF NODE
//        musicOnOffButton = SKSpriteNode(imageNamed: musicOn ? Filename.MusicOn : Filename.MusicOff)
//        musicOnOffButton!.position = CGPoint(x: -size.width / 2.0 + Geometry.PausedMusicOnOffNodeLeftOffset, y: -size.height / 2.0 + Geometry.PausedMusicOnOffNodeLowerOffset)
//        musicOnOffButton!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
//        musicOnOffButton!.name = NodeName.MusicOnOff
//        backgroundNode!.addChild(musicOnOffButton!)
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
