//
//  CurrencyExchangeDataResponse.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

struct CurrencyExchangeDataResponse: Decodable {
    let data: [String: Double]

    enum CodingKeys: CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(
            [String : Double].self,
            forKey: .data
        )
        .filter { data in
            Constants.availableCurrencies.contains(where: { $0.rawValue == data.key })
        }
    }

    init(data: [String: Double]) {
        self.data = data
    }
}
