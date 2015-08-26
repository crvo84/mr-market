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
    var currentPriceValue: Double
    var name: String
    private var beta: Double
    
    // uniqueName is also the logo filename
    init(uniqueName: String, beta: Double) {
        self.name = uniqueName
        self.beta = beta
        let randomLimit: UInt32 = CompanyInfo.MaxInitialPriceInteger - CompanyInfo.MinInitialPriceInteger + 1
        let priceInteger = Double(arc4random_uniform(randomLimit) + CompanyInfo.MinInitialPriceInteger)
        self.currentPriceValue = priceInteger + Double(arc4random_uniform(10)) / 10.0
    }
    
    func newPriceWithMarketReturn(marketReturn: Double) -> Price
    {
        // Add random deviation to the company beta
        let betaDeviation = (Double(arc4random_uniform(CompanyInfo.BetaMaxPercentDeviation * 2 + 1)) - Double(CompanyInfo.BetaMaxPercentDeviation)) / 100.0
        let companyReturn = marketReturn * beta * (1 + betaDeviation)
        currentPriceValue *= (1 + companyReturn)
        
        println("Company: " + name + ", Beta: \(beta), Price: \(currentPriceValue)")
        
        return Price(company: self, value: currentPriceValue)
    }
    
    class func generateCompanies(numberOfCompanies: Int) -> [Company] {
        var companies: [Company] = []
        
        var number = min(numberOfCompanies, Texture.numberOfBlockImages)
        
        let betaDiff = (CompanyInfo.MaxBeta - CompanyInfo.MinBeta) / Double(numberOfCompanies - 1)
        
        for i in 0..<numberOfCompanies {
            
            let beta = numberOfCompanies > 1 ? CompanyInfo.MinBeta + Double(i) * betaDiff : 1.0

            let name = Texture.blockImageNamePrefix + "\(i)"
            companies.append(Company(uniqueName: name, beta: beta))
        }
        
        return companies
    }
    
    class func newCompanyForIndex(index: Int) -> Company?
    {
        var company: Company? = nil
        
        if index < Texture.numberOfBlockImages {
            let name = Texture.blockImageNamePrefix + "\(index)"
            let randomLimit = UInt32(CompanyInfo.MaxBeta - CompanyInfo.MinBeta + 1)
            let beta = Double(arc4random_uniform(randomLimit)) + CompanyInfo.MinBeta
            company = Company(uniqueName: name, beta: beta)
        }
        return company
    }

    
}