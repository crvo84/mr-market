//
//  MrMarketGame.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/24/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation

class MrMarketGame
{
    var gameLevel: Int = 1 {
        didSet {
            updateCompanies()
            portfolio.transactionAmount += GameOption.TransactionAmountIncrease
        }
    }
    
    let market = Market(initialLevel: GameOption.InitialMarketLevel)
    
    var companies: [Company] = Company.generateCompanies(GameOption.NumberOfCompaniesInitial)
    
    let portfolio = Portfolio(transactionAmount: GameOption.TransactionAmountInitial)
    
    var numberOfPeriods: Int {
        return min(GameOption.PeriodsMax, GameOption.PeriodsInitial + GameOption.PeriodsIncrease * (gameLevel - 1))
    }
    
    var cash: Double {
        return portfolio.cash
    }
    
    private func updateCompanies()
    {
        let currentNumber = companies.count
        
        var numberOfCompaniesForCurrentLevel = GameOption.NumberOfCompaniesInitial + GameOption.NumberOfCompaniesIncrease * (gameLevel - 1)
        if numberOfCompaniesForCurrentLevel > Texture.numberOfBlockImages {
            numberOfCompaniesForCurrentLevel = Texture.numberOfBlockImages
        }

        let numberToAdd = numberOfCompaniesForCurrentLevel - currentNumber
        
        if numberToAdd <= 0 { return }
        
        for i in 0..<numberToAdd {
            let newCompany = Company.newCompanyForIndex(currentNumber + i)
            if newCompany != nil {
                companies.append(newCompany!)
            }
        }
    }
}