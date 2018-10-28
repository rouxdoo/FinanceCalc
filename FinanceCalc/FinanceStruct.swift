//
//  FinanceStruct.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/24/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

struct FinanceStruct {
    var job: Double
    var renewalCount: Int
    var renewalAmount: Double
    var taxRate: Double // 8.25, 7.75...
    var apr: Double // 18, 6...
    var term: Int // 12, 18, 24, 36...
    var percentDown: Double // 0, 20, 50
    // applicant data
    var lastName: String
    var firstName: String
    var middleInitial: String
    var address: String
    var city: String
    var state: String
    var zip: String
    var phone1: String
    var phone2: String
    var email: String
    var ssn: String
    var serviceAddress: String
    var description: String
    
    func monthlyPayment() -> Double {
        let loanTerm = Double(self.term)
        let ratePerPeriod = (self.apr / 100) / 12
        let pmt = (ratePerPeriod / (1 - (pow(1 + ratePerPeriod, loanTerm * -1)))) * amountFinanced()
        return pmt.roundToDecimal(2)
    }
    func renewalsTotal() -> Double {
        return Double(self.renewalCount) * self.renewalAmount
    }
    func totalJobPretax() -> Double {
        return self.job + self.renewalsTotal()
    }
    func taxes() -> Double {
        return (self.totalJobPretax() * (self.taxRate / 100)).roundToDecimal(2)
    }
    func totalCashPrice() -> Double {
        return self.totalJobPretax() + self.taxes()
    }
    func downPayment() -> Double {
        let rawdp = self.totalCashPrice() * (self.percentDown / 100)
        let dpModulo = (self.totalCashPrice() - rawdp).truncatingRemainder(dividingBy: 10)
        return rawdp + dpModulo
    }
    func amountFinanced() -> Double {
        return self.totalCashPrice() - self.downPayment()
    }
    func totalOfPayments() -> Double {
        return self.monthlyPayment() * Double(self.term)
    }
    func financeCharge() -> Double {
        return self.totalOfPayments() - self.amountFinanced()
    }
    func totalFinancedJob() -> Double {
        return self.totalOfPayments() + self.downPayment()
    }
}
