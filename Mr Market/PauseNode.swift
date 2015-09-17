//
//  PauseNode.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/21/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import SpriteKit

class PauseNode: SKSpriteNode {
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    private var backgroundNode: SKShapeNode?
    private var pausedLabelNode: SKLabelNode?
    private var continueButton: ButtonNode?
    private var restartButton: ButtonNode?
    private var quitButton: ButtonNode?
    private var musicOnOffButton: SKSpriteNode?
    
    init(size: CGSize, musicOn: Bool) {
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        // BACKGROUND
        let backgroundSize = CGSize(width: size.width * Geometry.PauseNodeRelativeWidth, height: size.height * Geometry.PauseNodeRelativeHeight)
        let backgroundCornerRadius = Geometry.PauseNodeRelativeCornerRadius * backgroundSize.width
        backgroundNode = SKShapeNode(rectOfSize: backgroundSize, cornerRadius: backgroundCornerRadius)
        backgroundNode!.fillColor = Color.PauseNodeBackground
        backgroundNode!.lineWidth = Geometry.PauseNodeBorderWidth
        backgroundNode!.strokeColor = Color.PauseNodeBorder
        addChild(backgroundNode!)
        
        // CONTINUE BUTTON
        let continueButtonWidth = backgroundSize.width * Geometry.PauseNodeLargeButtonRelativeWidth
        let continueButtonSize = CGSize(width: continueButtonWidth, height: backgroundSize.height * Geometry.PauseNodeButtonRelativeHeight)
        let continueButtonCornerRadius = Geometry.PauseNodeButtonRelativeCornerRadius * continueButtonSize.width
        
        continueButton = ButtonNode(size: continueButtonSize, cornerRadius: continueButtonCornerRadius, labelText: Text.Continue, imageTexture: nil)
        continueButton!.backgroundColor = Color.PauseNodeButton
        continueButton!.borderWidth = Geometry.PauseNodeButtonBorderWidth
        continueButton!.borderColor = Color.PauseNodeButtonBorder
        continueButton!.position = CGPoint(x: 0.0, y: Geometry.PauseNodeButtonVerticalSeparation + continueButtonSize.height / 2.0)
        continueButton!.labelFontName = FontName.PauseNodeButton
        continueButton!.labelFontColor = Color.PauseNodeButtonText
        continueButton!.name = NodeName.ContinueButton
        backgroundNode!.addChild(continueButton!)
        
        // small buttons
        let smallButtonSize = CGSize(width: continueButtonSize.width / 2 - Geometry.PauseNodeSmallButtonHorizontalSeparation, height: continueButtonSize.height)
        let smallButtonCornerRadius = Geometry.PauseNodeButtonRelativeCornerRadius * continueButtonSize.width
        
        // RESTART BUTTON
        restartButton = ButtonNode(size: smallButtonSize, cornerRadius: smallButtonCornerRadius, labelText: Text.Restart, imageTexture: nil)
        restartButton!.backgroundColor = Color.PauseNodeButton
        restartButton!.borderWidth = Geometry.PauseNodeButtonBorderWidth
        restartButton!.borderColor = Color.PauseNodeButtonBorder
        restartButton!.position = CGPoint(x: -smallButtonSize.width / 2.0 - Geometry.PauseNodeSmallButtonHorizontalSeparation, y: -Geometry.PauseNodeButtonVerticalSeparation - smallButtonSize.height / 2.0)
        restartButton!.labelFontName = FontName.PauseNodeButton
        restartButton!.labelFontColor = Color.PauseNodeButtonText
        restartButton!.name = NodeName.RestartButton
        backgroundNode!.addChild(restartButton!)
        
        // QUIT BUTTON
        quitButton = ButtonNode(size: smallButtonSize, cornerRadius: smallButtonCornerRadius, labelText: Text.Quit, imageTexture: nil)
        quitButton!.backgroundColor = Color.PauseNodeButton
        quitButton!.borderWidth = Geometry.PauseNodeButtonBorderWidth
        quitButton!.borderColor = Color.PauseNodeButtonBorder
        quitButton!.position = CGPoint(x: +smallButtonSize.width / 2.0 + Geometry.PauseNodeSmallButtonHorizontalSeparation, y: -Geometry.PauseNodeButtonVerticalSeparation - smallButtonSize.height / 2.0)
        quitButton!.labelFontName = FontName.PauseNodeButton
        quitButton!.labelFontColor = Color.PauseNodeButtonText
        quitButton!.name = NodeName.QuitButton
        backgroundNode!.addChild(quitButton!)
        
        // set equal size to restart and quit button labels
        let smallestFontSize = min(restartButton!.labelFontSize, quitButton!.labelFontSize)
        restartButton!.labelFontSize = smallestFontSize
        quitButton!.labelFontSize = smallestFontSize
        
        // PAUSED LABEL
        pausedLabelNode = SKLabelNode(text: Text.Paused)
        pausedLabelNode!.fontColor = Color.PausedLabel
        pausedLabelNode!.fontName = FontName.PausedLabel
        pausedLabelNode!.fontSize = isIpad ? FontSize.PausedLabelIpad : FontSize.PausedLabelIphone
        pausedLabelNode!.verticalAlignmentMode = .Center
        pausedLabelNode!.horizontalAlignmentMode = .Center
        let pausedLabelY = backgroundNode!.frame.size.height / 4.0 + (continueButton!.position.y + continueButton!.size.height / 2.0) / 2.0
        pausedLabelNode!.position = CGPoint(x: 0.0 , y: pausedLabelY)
        backgroundNode!.addChild(pausedLabelNode!)
        
        // MUSIC ON/OFF NODE
        musicOnOffButton = SKSpriteNode(imageNamed: musicOn ? Filename.MusicOn : Filename.MusicOff)
        musicOnOffButton!.position = CGPoint(x: -size.width / 2.0 + Geometry.PausedMusicOnOffNodeLeftOffset, y: -size.height / 2.0 + Geometry.PausedMusicOnOffNodeLowerOffset)
        musicOnOffButton!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        musicOnOffButton!.name = NodeName.MusicOnOff
        backgroundNode!.addChild(musicOnOffButton!)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
