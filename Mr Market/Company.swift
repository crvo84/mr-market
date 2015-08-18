//
//  Company.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation

class Company: NSObject
{
    var currentPrice: Double
    var name: String
    private var beta: Double
    
    // uniqueName is also the logo filename
    init(uniqueName: String, beta: Double) {
        self.name = uniqueName
        self.beta = beta
        let randomLimit: UInt32 = CompanyInfo.MaxInitialPriceInteger - CompanyInfo.MinInitialPriceInteger + 1
        let priceInteger = Double(arc4random_uniform(randomLimit) + CompanyInfo.MinInitialPriceInteger)
        self.currentPrice = priceInteger + Double(arc4random_uniform(10)) / 10.0
        
        println("Company: " + name + ", Beta: \(beta), Price: \(currentPrice)")
    }
    
    func newPriceWithMarketReturn(marketReturn: Double) -> Double
    {
        // Add random deviation to the company beta
        let betaDeviation = Double(arc4random_uniform(CompanyInfo.BetaMaxPercentDeviation * 2 + 1) - CompanyInfo.BetaMaxPercentDeviation) / 100.0
        currentPrice = marketReturn * beta * (1 + betaDeviation)
        return currentPrice
    }
    
    class func generateCompanies(numberOfCompanies: Int) -> [Company] {
        var companies: [Company] = []
        
        var number = min(numberOfCompanies, Texture.numberOfBlockImages)
        
        let betaDiff = (CompanyInfo.MaxBeta - CompanyInfo.MinBeta) / Double(numberOfCompanies - 1)
        
        for i in 0..<numberOfCompanies {
            let beta = CompanyInfo.MinBeta + Double(i) * betaDiff
            let name = Texture.blockImageNamePrefix + "\(i)"
            companies.append(Company(uniqueName: name, beta: beta))
        }
        
        return companies
    }

    
}