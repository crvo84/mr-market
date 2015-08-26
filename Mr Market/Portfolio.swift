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
    var cash: Double = 0.0
    
    var transactionAmount: Double
    
    init(transactionAmount: Double) {
        self.transactionAmount = transactionAmount
    }
    
    func buyPrice(price: Price) {
        let index = find(prices, price)
        if index == nil {
            prices.append(price)
            println("Block purchased")
        }
    }
    
    func sellPrice(priceToSell: Price) {
        if let index = find(prices, priceToSell) {
            cash += (priceToSell.company.currentPriceValue / priceToSell.value - 1) * transactionAmount
            prices.removeAtIndex(index)
            if cash <= 0.0 { cash = 0.0 }
            println("Block Sold. Portfolio cash: \(cash)")
        }
    }
}



