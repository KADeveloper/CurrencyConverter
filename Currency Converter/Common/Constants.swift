//
//  Constants.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

enum Constants {
    static let availableCurrencies = AvailableCurrency.allCases
}

enum AvailableCurrency: String, CaseIterable, Identifiable {
    case chf = "CHF"
    case cny = "CNY"
    case eur = "EUR"
    case gbp = "GBP"
    case rub = "RUB"
    case usd = "USD"

    var id: String { rawValue }
    var code: String { rawValue }
}
