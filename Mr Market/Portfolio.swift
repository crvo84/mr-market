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
    private var cash: Double = 0.0
    
    
    func buyPrice(price: Price) {
        prices.append(price)
    }
    
    func sellPrice(priceToSell: Price) {
        if let index = find(prices, priceToSell) {
//            cash += (priceToSell.company.currentPrice / priceToSell.value - 1) * CompanyInfo.TransactionAmount
            cash += priceToSell.company.currentPrice - priceToSell.value
            prices.removeAtIndex(index)
            if cash <= 0.0 { cash = 0.0 }
        }
    }
}



