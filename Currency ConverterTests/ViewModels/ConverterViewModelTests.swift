//
//  ConverterViewModelTests.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/2/24.
//

import XCTest
import Dependencies
import SwiftData
@testable import Currency_Converter

@MainActor
private struct DependenciesContainer {
    private let currencyListResponseMock = CurrencyListResponseMock()

    let responseMock = CurrencyExchangeDataResponseMock()

    let networking = NetworkingMock()
    let modelContext: ModelContext
    let currencyList: CurrencyListModel

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(
            for: HistoryModel.self, CurrencyListModel.self, CurrencyExchangeRatesModel.self,
            configurations: config
        )

        var currencyList = CurrencyListModel(
            currencies: currencyListResponseMock.defaultValue.currenciesInfo.map {
                CurrencyModel(
                    name: $0.name,
                    code: $0.code,
                    nativeSymbol: $0.symbolNative,
                    decimalDigits: $0.decimalDigits
                )
            }
        )

        modelContainer.mainContext.insert(currencyList)

        modelContext = modelContainer.mainContext
        self.currencyList = currencyList
    }
}

@MainActor
final class ConverterViewModelTests: XCTestCase {
    private var container: DependenciesContainer!
    private var sut: ConverterViewModel!

    override func setUp() {
        super.setUp()
        container = try! DependenciesContainer()
    }

    override func tearDown() {
        container = nil
        sut = nil
        super.tearDown()
    }

    // MARK: View Actions
    func testDidSelectCurrency() throws {
        // Given
        let currencies = container.currencyList.currencies.sorted(by: { $0.code < $1.code })
        sut = try makeSut(with: container.modelContext)

        // Result
        XCTAssertEqual(sut.state.selectedCurrency, currencies.first)

        // Action
        sut.handleViewAction(.didSelect(currency: currencies.last!))

        // Result
        XCTAssertEqual(sut.state.selectedCurrency, currencies.last)
    }

    func testChangeAmountViewAction() throws {
        // Given
        sut = try makeSut(with: container.modelContext)

        // Result
        XCTAssertEqual(sut.state.amountToExchange, .zero)

        // Action
        sut.handleViewAction(.didChange(amount: 10.3))

        // Result
        XCTAssertEqual(sut.state.amountToExchange, 10.30)
    }

    func testRetryViewAction() async throws {
        // Given
        sut = try makeSut(with: container.modelContext)

        // Action
        container.networking.loadExchangeRateResult = container.responseMock.defaultResponse
        let task = Task { try await container.networking.loadExchangeRate(for: sut.state.selectedCurrency.code) }

        // Result
        XCTAssertEqual(sut.state.networkingState, .isLoading)
        await Task.yield()
        _ = try await task.value
        XCTAssertEqual(sut.state.networkingState, .loaded)
        XCTAssertTrue(container.networking.isLoadExchangeRateCalled)


        // Action
        container.networking.loadExchangeRateResult = container.responseMock.defaultResponse
        sut.handleViewAction(.retry)
        let retryTask = Task { try await container.networking.loadExchangeRate(for: sut.state.selectedCurrency.code) }

        // Result
        XCTAssertEqual(sut.state.networkingState, .isLoading)
        await Task.yield()
        _ = try await retryTask.value
        XCTAssertEqual(sut.state.networkingState, .loaded)
    }

    func testSwapViewAction() throws {
        // Given
        let currencies = container.currencyList.currencies.sorted(by: { $0.code < $1.code })
        sut = try makeSut(with: container.modelContext)

        // Result
        XCTAssertEqual(sut.state.selectedCurrency, currencies.first)
        XCTAssertEqual(sut.state.exchangeCurrency, currencies.last)

        // Action
        sut.handleViewAction(.swapCurrencies)

        // Result
        XCTAssertEqual(sut.state.selectedCurrency, currencies.last)
        XCTAssertEqual(sut.state.exchangeCurrency, currencies.first)
    }


    private func makeSut(with modelContext: ModelContext) throws -> ConverterViewModel {
        return withDependencies { value in
            let di = DependenciesContainerProtocolMock(networking: container.networking)
            value.di = di
        } operation: {
            ConverterViewModel(currencyList: container.currencyList,
                               modelContext: modelContext)
        }
    }
}
