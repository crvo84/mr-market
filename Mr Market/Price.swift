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
       return String(format: "$%.1f", value)
    }
}