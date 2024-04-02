//
//  CurrencyListResponseMock.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation
@testable import Currency_Converter

struct CurrencyListResponseMock {
    let emptyResponse = CurrencyListResponse(currenciesInfo: [])

    let defaultValue = CurrencyListResponse(
        currenciesInfo: [
            CurrencyResponse(
                name: "USD",
                symbolNative: "USD",
                code: "USD",
                namePlural: "USD",
                decimalDigits: 2,
                rounding: 2
            ),
            CurrencyResponse(
                name: "EUR",
                symbolNative: "EUR",
                code: "EUR",
                namePlural: "EUR",
                decimalDigits: 2,
                rounding: 0
            )
        ]
    )

    let oneValue = CurrencyListResponse(
        currenciesInfo: [
            CurrencyResponse(
                name: "USD",
                symbolNative: "USD",
                code: "USD",
                namePlural: "USD",
                decimalDigits: 2,
                rounding: 2
            )
        ]
    )
}
