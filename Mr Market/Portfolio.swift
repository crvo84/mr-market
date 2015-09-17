//
//  Portfolio.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation

class Portfolio
{
    private var prices: [Price] = []
    
    var cash: Double
    var transactionAmount: Double
    
    init(initialCash: Double, transactionAmount: Double) {
        self.cash = initialCash
        self.transactionAmount = transactionAmount
    }
    
    // Return true if the price was purchased, false otherwise (e.g. no enough cash)
    func buyPrice(price: Price) -> Bool {
        let index = prices.indexOf(price)
        if index == nil && cash >= transactionAmount {
            // If the price was not already purchased, or if enough cash available
            cash -= transactionAmount
            prices.append(price)
            print("Block purchased")
            return true
        }
        
        print("Block not purchased")
        return false
    }
    
    func sellPrice(priceToSell: Price) {
        if let index = prices.indexOf(priceToSell) {
//            cash += (priceToSell.company.currentPriceValue / priceToSell.value - 1) * transactionAmount
            cash += (priceToSell.company.currentPriceValue / priceToSell.value) * transactionAmount
            prices.removeAtIndex(index)
//            if cash <= 0.0 { cash = 0.0 }
        }
    }
    
    func sellPriceWithoutProfitOrLoss(priceToSell: Price) {
        if let index = prices.indexOf(priceToSell) {
            cash += transactionAmount
            prices.removeAtIndex(index)
        }
    }
}



