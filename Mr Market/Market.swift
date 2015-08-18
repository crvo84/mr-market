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
        let levelIncrease = continueTrend ? MarketOptions.LevelIncrease : -MarketOptions.LevelIncrease
        var newLevel = level + levelIncrease
        
        if newLevel > MrMarket.Info.MaxLevel {
            level = MrMarket.Info.MinLevel
        } else if newLevel < MrMarket.Info.MinLevel {
            level = MrMarket.Info.MaxLevel
        } else {
            level = newLevel
        }
        
        let randomReturn: Double = Double(arc4random_uniform(MarketOptions.MaxPercentReturn * 10 + 1)) / 10 * volatility
        
        lastReturn = level <= MrMarket.Info.TopBubbleLevel ? randomReturn : -randomReturn
        
        return level
    }
}