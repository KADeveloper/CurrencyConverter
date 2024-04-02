//
//  ConverterExchangeRatesModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/2/24.
//

import Foundation

struct ConverterExchangeRatesModel {
    let rates: [ConverterExchangeRateModel]
    let date: Date

    init(rates: [ConverterExchangeRateModel],
         date: Date = .now) {
        self.rates = rates
        self.date = date
    }
}

struct ConverterExchangeRateModel {
    let rates: [String: Double]
}
