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
    
//    func newPriceWithMarketReturn(marketReturn: Double) -> Price
    func newPriceWithMarketReturn(marketReturn: Double)
    {
        // Add random deviation to the company beta
        let betaDeviation = (Double(arc4random_uniform(CompanyInfo.BetaMaxPercentDeviation * 2 + 1)) - Double(CompanyInfo.BetaMaxPercentDeviation)) / 100.0
        let companyReturn = marketReturn * beta * (1 + betaDeviation)
        currentPriceValue *= (1 + companyReturn)

//        return Price(company: self, value: currentPriceValue)
    }
    
    class func newPricesWithMarketReturn(marketReturn: Double, forCompanies companies: [Company]) {
        for company in companies {
            company.newPriceWithMarketReturn(marketReturn)
        }
    }
    
    class func generateCompanies(numberOfCompanies: Int) -> [Company] {
        var companies: [Company] = []
        
        var number = min(numberOfCompanies, Texture.numberOfBlockImages)
        
        // generate all names
        var allNames: [String] = []
        for i in 0..<Texture.numberOfBlockImages {
            allNames.append(Texture.blockImageNamePrefix + "\(i)")
        }
        
        let betaDiff = number > 1 ? (CompanyInfo.MaxBeta - CompanyInfo.MinBeta) / Double(numberOfCompanies - 1) : 0.0
        
        // create random companies
        for i in 0..<number {
            let beta = number > 1 ? CompanyInfo.MinBeta + Double(i) * betaDiff : (CompanyInfo.MaxBeta + CompanyInfo.MinBeta) / 2.0
            
            let randomIndex = Int(arc4random_uniform(UInt32(allNames.count)))
            companies.append(Company(uniqueName: allNames[randomIndex], beta: beta))
            allNames.removeAtIndex(randomIndex)
        }
        
        return companies
    }
    

    class func newCompanyForCurrentCompanies(currentCompanies: [Company]) -> Company?
    {
        var company: Company? = nil

        // existing names
        var existingNames: [String] = []
        for i in 0..<currentCompanies.count {
            existingNames.append(currentCompanies[i].name)
        }
        
        // generate remaining names
        var remainingNames: [String] = []
        for i in 0..<Texture.numberOfBlockImages {
            let newName = Texture.blockImageNamePrefix + "\(i)"
            if !contains(existingNames, newName) {
                remainingNames.append(newName)
            }
        }
        
        if remainingNames.count > 0 {
            let randomLimit = UInt32(CompanyInfo.MaxBeta - CompanyInfo.MinBeta + 1)
            let randomBeta = Double(arc4random_uniform(randomLimit)) + CompanyInfo.MinBeta
            
            let randomIndex = Int(arc4random_uniform(UInt32(remainingNames.count)))
            
            company = Company(uniqueName: remainingNames[randomIndex], beta: randomBeta )
        }
        
        return company
    }

    
}