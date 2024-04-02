//
//  CurrencyExchangeRatesModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/2/24.
//

import Foundation
import SwiftData

@Model
class CurrencyExchangeRatesModel {
    @Relationship(deleteRule: .cascade) let rates: [CurrencyExchangeRateModel]

    let date: Date

    init(rates: [CurrencyExchangeRateModel]) {
        self.rates = rates
        self.date = .now
    }
}

@Model
class CurrencyExchangeRateModel {
    let rate: [String: Double]

    init(rate: [String : Double]) {
        self.rate = rate
    }
}
