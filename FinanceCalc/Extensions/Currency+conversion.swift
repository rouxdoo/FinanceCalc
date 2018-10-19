//
//  Currency+conversion.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/18/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import Foundation

extension String {
    func currencyToDouble() -> Double {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.number(from: self) as! Double? ?? 0
    }
}
extension Double {
    var asCurrency:String {
        let formatter = NumberFormatter.localizedString(from: NSNumber(value: self), number: .currency)
        return formatter
    }
}
