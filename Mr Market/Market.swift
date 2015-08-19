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
    var level: Int // [0, 15]
    var volatility: Double = 1.0
    var lastReturn: Double = 0.0
    
    
    init(volatility: Double) {
        self.volatility = volatility
        self.level = Int(arc4random_uniform(UInt32(MrMarket.Info.MaxLevel + 1)))
    }
    
    func newMarketLevel() -> Int {
        let continueTrend = Double(arc4random_uniform(UInt32(100 + 1))) / 100.0 > MarketOptions.ProbabilityOfBreakingTrend

        var newLevel = level + 1 // TODO: Add volatility here
        
        if newLevel > MrMarket.Info.MaxLevel {
            level = MrMarket.Info.MinLevel
        } else if newLevel < MrMarket.Info.MinLevel {
            level = MrMarket.Info.MaxLevel
        } else {
            level = newLevel
        }
        println("New Market Level")

        let randomLimit = (MarketOptions.MaxPercentReturn - MarketOptions.MinPercentReturn) * 10 + 1
        let randomPercentReturn = Double(arc4random_uniform(UInt32(randomLimit))) / 10 + MarketOptions.MinPercentReturn
        let randomReturn = randomPercentReturn / 100.0
        
        lastReturn = level < MrMarket.Info.BurstLevel ? randomReturn : -randomReturn * MarketOptions.BurstReturnFactor
        
        println("Market. Last Return: \(lastReturn), Level: \(level)")
        
        return level
    }
}