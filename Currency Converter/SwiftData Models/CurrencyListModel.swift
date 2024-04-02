//
//  CurrencyListModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation
import SwiftData

@Model
class CurrencyListModel {
    @Relationship(deleteRule: .cascade) let currencies: [CurrencyModel]

    let date: Date

    init(currencies: [CurrencyModel]) {
        self.currencies = currencies
        date = .now
    }
}

@Model
class CurrencyModel {
    let name: String
    let code: String
    let nativeSymbol: String
    let decimalDigits: Int

    init(
        name: String,
        code: String,
        nativeSymbol: String,
        decimalDigits: Int
    ) {
        self.name = name
        self.code = code
        self.nativeSymbol = nativeSymbol
        self.decimalDigits = decimalDigits
    }
}
