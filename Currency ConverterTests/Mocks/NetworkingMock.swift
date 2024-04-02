//
//  NetworkingMock.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation
@testable import Currency_Converter

final class NetworkingMock: Networking {
    enum MockError: Error {
        case mock
    }

    var isLoadCurrenciesCalled: Bool = false
    var loadCurrenciesResult: CurrencyListResponse?

    var isLoadExchangeRateCalled: Bool = false
    var loadExchangeRateResult: CurrencyExchangeDataResponse?

    func loadCurrencies() async throws -> CurrencyListResponse {
        isLoadCurrenciesCalled = true

        if let result = loadCurrenciesResult {
            return result
        } else {
            throw MockError.mock
        }
    }

    func loadExchangeRate(for currency: String) async throws -> CurrencyExchangeDataResponse {
        isLoadExchangeRateCalled = true

        if let result = loadExchangeRateResult {
            return result
        } else {
            throw MockError.mock
        }
    }
}
