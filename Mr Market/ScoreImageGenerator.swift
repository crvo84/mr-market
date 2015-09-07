//
//  ScoreImageGenerator.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//


import SpriteKit
import UIKit

class ScoreImageGenerator {
    
    private struct ScoreImage {
        // title
        static let TitleColor = SKColor.whiteColor()
        static let TitleFontSize: CGFloat = 34
        static let TitleFontName = "Gill Sans"
        static let TitleUpperOffset: CGFloat = 12
        static let TitleLeftOffset: CGFloat = 45
        // score
        static let ScoreColor = SKColor(red: 255/255, green: 204/255, blue: 102/255, alpha: 1.0)
        static let ScoreFontSize: CGFloat = 24
        static let ScoreFontName = "Gill Sans"
        static let ScoreLowerOffset: CGFloat = 22
        // cash
        static let CashColor = ScoreImage.ScoreColor
        static let CashFontSize: CGFloat = 26
        static let CashFontName = ScoreImage.ScoreFontName
        static let CashUpperOffset: CGFloat = 8
        
    }

    func scoreImageWithText(scoreText: String) -> UIImage? {
        let baseTexture = SKTexture(imageNamed: Filename.ScoreShare)
        let size = baseTexture.size()
        let skView = SKView(frame: CGRectMake(0.0, 0.0, size.width, size.height))
        let scene = SKScene(size: size)
        
        // base node
        let baseNode = SKSpriteNode(texture: baseTexture)
        baseNode.position = CGPoint(x: scene.size.width / 2.0, y: scene.size.height / 2.0)
        
        // add title label node
        let titleNode = SKLabelNode(text: Text.MrMarket)
        titleNode.fontSize = ScoreImage.TitleFontSize
        titleNode.fontName = ScoreImage.TitleFontName
        titleNode.color = ScoreImage.TitleColor
        titleNode.verticalAlignmentMode = .Top
        titleNode.horizontalAlignmentMode = .Center
        titleNode.position = CGPoint(x: ScoreImage.TitleLeftOffset, y: baseNode.size.height / 2.0 - ScoreImage.TitleUpperOffset)
        baseNode.addChild(titleNode)
        
        // add score label node
        let scoreNode = SKLabelNode(text: Text.Score)
        scoreNode.fontSize = ScoreImage.ScoreFontSize
        scoreNode.fontName = ScoreImage.ScoreFontName
        scoreNode.fontColor = ScoreImage.ScoreColor
        scoreNode.verticalAlignmentMode = .Top
        scoreNode.horizontalAlignmentMode = .Center
        scoreNode.position = CGPoint(x: titleNode.position.x, y: ScoreImage.ScoreLowerOffset)
        baseNode.addChild(scoreNode)
        
        // add cash label node
        let cashNode = SKLabelNode(text: scoreText)
        cashNode.fontSize = ScoreImage.CashFontSize
        cashNode.fontName = ScoreImage.CashFontName
        cashNode.fontColor = ScoreImage.CashColor
        cashNode.verticalAlignmentMode = .Top
        cashNode.horizontalAlignmentMode = .Center
        cashNode.position = CGPoint(x: scoreNode.position.x, y: scoreNode.position.y - scoreNode.frame.size.height - ScoreImage.CashUpperOffset)
        baseNode.addChild(cashNode)
        
        scene.addChild(baseNode)
        skView.presentScene(scene)
        
        return imageWithView(skView)
    }

    
    private func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }


}