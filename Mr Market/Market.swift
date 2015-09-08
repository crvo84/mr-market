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
    var level: Int // [0, 4]
    var volatility: Double = 1.0
    var latestReturn: Double = 0.0
    
    
    init(initialLevel: Int) {
//        self.level = Int(arc4random_uniform(UInt32(MrMarket.Info.MaxLevel + 1)))
        self.level = initialLevel
    }
    
    func newMarketLevel() -> Int {
        // probability of breaking market trend
        let continueTrend = Double(arc4random_uniform(UInt32(100 + 1))) / 100.0 > MarketOption.ProbabilityOfBreakingTrend
        
        var newLevel = continueTrend ? level + 1 : level - 1
        
        // From maxLevel to minLevel
        if newLevel > MrMarket.Info.MaxLevel {
            level = MrMarket.Info.MinLevel
        } else if newLevel < MrMarket.Info.MinLevel {
            level = MrMarket.Info.MaxLevel
        } else {
            level = newLevel
        }
        println("New Market Level")

        // new random return
        let randomLimit = (MarketOption.MaxPercentReturn - MarketOption.MinPercentReturn) * 10 + 1
        let randomPercentReturn = Double(arc4random_uniform(UInt32(randomLimit))) / 10 + MarketOption.MinPercentReturn
        let randomReturn = randomPercentReturn / 100.0
        
        var newReturn = level < MrMarket.Info.BurstLevel ? randomReturn : -randomReturn * MarketOption.BurstReturnFactor
        // when breaking trend, change return sign only if NOT coming from an inflection point
        if !continueTrend {
            if level != MrMarket.Info.MaxLevel && level != MrMarket.Info.BurstLevel - 1 {
                newReturn = -newReturn
            }
        }
        
        latestReturn = newReturn
        
        println("Market. Latest Return: \(latestReturn), Level: \(level)")
        
        return level
    }
}