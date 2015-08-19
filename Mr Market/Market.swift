//
//  Market.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation

class Market
{
    var level: Double // [0, 100]
    var volatility: Double = 1.0
    var lastReturn: Double = 0.0
    
    
    init(volatility: Double) {
        self.volatility = volatility
        self.level = Double(arc4random_uniform(100 + 1))
    }
    
    func newMarketLevel() -> Double {
        let continueTrend = Double(arc4random_uniform(UInt32(100 + 1))) / 100.0 > MarketOptions.ProbabilityOfBreakingTrend
        
        let levelIncrease: Double
        
        if level < 50.0 {
            // Boom
            levelIncrease = continueTrend ? MarketOptions.LevelIncreaseBoom : (level == 0.0 ? MarketOptions.LevelIncreaseBurst : MarketOptions.LevelIncreaseBoom)
        } else {
            // Burst
            if continueTrend {
                levelIncrease = level == 100.0 ? MarketOptions.LevelIncreaseBoom : MarketOptions.LevelIncreaseBurst
            } else {
                levelIncrease = level == 50.0 ? MarketOptions.LevelIncreaseBoom : MarketOptions.LevelIncreaseBurst
            }
        }

        var newLevel = level + levelIncrease
        
        if newLevel > MrMarket.Info.MaxLevel {
            level = MrMarket.Info.MinLevel
        } else if newLevel < MrMarket.Info.MinLevel {
            level = MrMarket.Info.MaxLevel
        } else {
            level = newLevel
        }
        
        // TODO: sharper movements after level 50?

        let randomLimit = (MarketOptions.MaxPercentReturn - MarketOptions.MinPercentReturn) * 10 + 1
        let randomPercentReturn = Double(arc4random_uniform(UInt32(randomLimit))) / 10 + MarketOptions.MinPercentReturn
        let randomReturn = randomPercentReturn / 100.0
        
        lastReturn = level <= MrMarket.Info.TopBubbleLevel ? randomReturn : -randomReturn
        
        println("Market. Last Return: \(lastReturn), Level: \(level)")
        
        return level
    }
}