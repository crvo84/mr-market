//
//  Price.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import Foundation

class Price: NSObject
{
    let company: Company
    let value: Double
    
    init(company: Company, value: Double) {
        self.company = company
        self.value = value
    }
    
    func toString() -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
        numberFormatter.numberStyle = .CurrencyStyle
        return numberFormatter.stringFromNumber(NSNumber(double: value))!
    }
    
    class func cashString(cash: Double) -> String? {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
        numberFormatter.numberStyle = .CurrencyStyle
        if let cashString = numberFormatter.stringFromNumber(NSNumber(double: cash)) {
            return cashString
        }
        return nil
    }
}