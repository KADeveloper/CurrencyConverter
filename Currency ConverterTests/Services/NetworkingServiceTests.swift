//
//  NetworkingServiceTests.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import XCTest
@testable import Currency_Converter

final class NetworkingServiceTests: XCTestCase {
    func testLoadCurrencies() async throws {
        // Given
        let networking: Networking = HTTPClient()

        // Action
        let response = try await networking.loadCurrencies()

        // Result
        XCTAssertTrue(!response.currenciesInfo.isEmpty, "Currencies should be available")
    }

    func testLoadExchangeRate() async throws {
        // Given
        let networking: Networking = HTTPClient()
        let currencyCode = "USD"

        // Action
        let curencyList = try await networking.loadExchangeRate(for: currencyCode).data

        // Result
        XCTAssertNotNil(curencyList[currencyCode], "Currency should be available")
        XCTAssertTrue(curencyList[currencyCode] == 1, "Currency rate should be 1")
    }

    func testLoadUnavailableExchangeRate() async throws {
        // Given
        let networking: Networking = HTTPClient()
        let currencyCode = "Converter"

        // Action
        let curencyList = try await networking.loadExchangeRate(for: currencyCode).data

        // Result
        XCTAssertNil(curencyList[currencyCode], "Searching currency shouldn't be available")
    }
}
