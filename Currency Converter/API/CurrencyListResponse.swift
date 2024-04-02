//
//  CurrencyListResponse.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

struct CurrencyListResponse: Decodable {
    let currenciesInfo: [CurrencyResponse]

    enum CodingKeys: CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currenciesInfo = try container.decode(
            [String: CurrencyResponse].self,
            forKey: .data
        )
        .compactMap { data in
            if Constants.availableCurrencies.contains(where: { $0.rawValue == data.key }) {
                return data.value
            } else {
                return nil
            }
        }
    }

    init(currenciesInfo: [CurrencyResponse]) {
        self.currenciesInfo = currenciesInfo
    }
}

struct CurrencyResponse: Decodable {
    let name, symbolNative, code, namePlural: String
    let decimalDigits, rounding: Int

    enum CodingKeys: String, CodingKey {
        case name, rounding, code
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case namePlural = "name_plural"
    }
}
