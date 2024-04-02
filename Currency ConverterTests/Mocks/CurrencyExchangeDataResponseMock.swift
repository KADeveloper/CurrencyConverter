//
//  CurrencyExchangeDataResponseMock.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/2/24.
//

import Foundation
@testable import Currency_Converter

struct CurrencyExchangeDataResponseMock {
    let defaultResponse = CurrencyExchangeDataResponse(data: ["USD": 1, "EUR": 2])
}
