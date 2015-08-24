//
//  PauseNode.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/21/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation
import SpriteKit

class PauseNode: SKSpriteNode
{
    // Device
    private let isIpad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
    
    private var backgroundNode: SKShapeNode?
    private var pausedLabelNode: SKLabelNode?
    private var continueButton: ButtonNode?
    private var restartButton: ButtonNode?
    private var quitButton: ButtonNode?
//    private var musicOnOffButton: SKSpriteNode?
    
    init(size: CGSize) {
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
        let continueButtonSize = CGSize(width: backgroundSize.width * Geometry.PauseNodeLargeButtonRelativeWidth, height: backgroundSize.height * Geometry.PauseNodeButtonRelativeHeight)
        let continueButtonCornerRadius = Geometry.PauseNodeButtonRelativeCorderRadius * continueButtonSize.width
        
        continueButton = ButtonNode(size: continueButtonSize, cornerRadius: continueButtonCornerRadius, labelText: Text.Continue)
        continueButton!.backgroundColor = Color.PauseNodeButton
        continueButton!.borderWidth = Geometry.PauseNodeButtonBorderWidth
        continueButton!.borderColor = Color.PauseNodeButtonBorder
        continueButton!.position = CGPoint(x: 0.0, y: Geometry.PauseNodeButtonVerticalSeparation + continueButtonSize.height / 2.0)
        continueButton!.labelFontName = FontName.PauseNodeButtons
        continueButton!.labelFontSize = isIpad ? FontSize.PauseNodeLargeButtonIpad : FontSize.PauseNodeLargeButtonIphone
        continueButton!.labelFontColor = Color.PauseNodeButtonText
        continueButton!.name = NodeName.ContinueButton
        backgroundNode!.addChild(continueButton!)
        
        // small buttons
        let smallButtonSize = CGSize(width: continueButtonSize.width / 2 - Geometry.PauseNodeSmallButtonHorizontalSeparation, height: continueButtonSize.height)
        let smallButtonCornerRadius = Geometry.PauseNodeButtonRelativeCorderRadius * continueButtonSize.width
        
        // RESTART BUTTON
        restartButton = ButtonNode(size: smallButtonSize, cornerRadius: smallButtonCornerRadius, labelText: Text.Restart)
        restartButton!.backgroundColor = Color.PauseNodeButton
        restartButton!.borderWidth = Geometry.PauseNodeButtonBorderWidth
        restartButton!.borderColor = Color.PauseNodeButtonBorder
        restartButton!.position = CGPoint(x: -smallButtonSize.width / 2.0 - Geometry.PauseNodeSmallButtonHorizontalSeparation, y: -Geometry.PauseNodeButtonVerticalSeparation - smallButtonSize.height / 2.0)
        restartButton!.labelFontName = FontName.PauseNodeButtons
        restartButton!.labelFontSize = isIpad ? FontSize.PauseNodeSmallButtonIpad : FontSize.PauseNodeSmallButtonIphone
        restartButton!.labelFontColor = Color.PauseNodeButtonText
        restartButton!.name = NodeName.RestartButton
        backgroundNode!.addChild(restartButton!)
        
        // QUIT BUTTON
        quitButton = ButtonNode(size: smallButtonSize, cornerRadius: smallButtonCornerRadius, labelText: Text.Quit)
        quitButton!.backgroundColor = Color.PauseNodeButton
        quitButton!.borderWidth = Geometry.PauseNodeButtonBorderWidth
        quitButton!.borderColor = Color.PauseNodeButtonBorder
        quitButton!.position = CGPoint(x: +smallButtonSize.width / 2.0 + Geometry.PauseNodeSmallButtonHorizontalSeparation, y: -Geometry.PauseNodeButtonVerticalSeparation - smallButtonSize.height / 2.0)
        quitButton!.labelFontName = FontName.PauseNodeButtons
        quitButton!.labelFontSize = isIpad ? FontSize.PauseNodeSmallButtonIpad : FontSize.PauseNodeSmallButtonIphone
        quitButton!.labelFontColor = Color.PauseNodeButtonText
        quitButton!.name = NodeName.QuitButton
        backgroundNode!.addChild(quitButton!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
