//
//  WelcomeViewModelTests.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import XCTest
import Dependencies
import SwiftData
@testable import Currency_Converter

private struct DependenciesContainer {
    let networking = NetworkingMock()
    let responseMock = CurrencyListResponseMock()

    lazy var sut = withDependencies { value in
        let di = DependenciesContainerProtocolMock(networking: networking)
        value.di = di
    } operation: {
        WelcomeViewModel()
    }
}

@MainActor
final class WelcomeViewModelTests: XCTestCase {
    private var container: DependenciesContainer!

    override func setUp() {
        super.setUp()
        container = DependenciesContainer()
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    // MARK: ViewAction
    func testViewAppeared() async throws {
        // Given
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: CurrencyListModel.self, configurations: config)
        let fetchDescriptor = FetchDescriptor<CurrencyListModel>()

        // Action
        container.sut.handleViewAction(.viewAppeared(modelContext: modelContainer.mainContext))

        // Result
        XCTAssertTrue(container.sut.state == .loading)

        // Action
        container.networking.loadCurrenciesResult = container.responseMock.defaultValue
        let task = Task { try await container.networking.loadCurrencies() }
        await Task.yield()
        _ = try await task.value

        // Result
        let model = try modelContainer.mainContext.fetch(fetchDescriptor)
        XCTAssertNotNil(model.last)
        XCTAssertEqual(model.last?.currencies.count, 2)
        XCTAssertTrue(container.networking.isLoadCurrenciesCalled)
        XCTAssertNotNil(container.sut.tabBarViewModel)
    }

    func testViewAppearedWithOneItemInResponse() async throws {
        // Given
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: CurrencyListModel.self, configurations: config)
        let fetchDescriptor = FetchDescriptor<CurrencyListModel>()

        // Action
        container.sut.handleViewAction(.viewAppeared(modelContext: modelContainer.mainContext))

        // Result
        XCTAssertTrue(container.sut.state == .loading)

        // Action
        container.networking.loadCurrenciesResult = container.responseMock.oneValue
        let task = Task { try await container.networking.loadCurrencies() }
        await Task.yield()
        _ = try await task.value

        // Result
        let model = try modelContainer.mainContext.fetch(fetchDescriptor)
        XCTAssertNil(model.last)
        XCTAssertTrue(container.networking.isLoadCurrenciesCalled)
        XCTAssertNil(container.sut.tabBarViewModel)
        XCTAssertTrue(container.sut.state == .emptyData)
    }

    func testRetryViewAction() async throws {
        // Given
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: CurrencyListModel.self, configurations: config)
        let fetchDescriptor = FetchDescriptor<CurrencyListModel>()

        // Action
        container.sut.handleViewAction(.viewAppeared(modelContext: modelContainer.mainContext))
        container.sut.handleViewAction(.retry)
        container.networking.loadCurrenciesResult = container.responseMock.emptyResponse
        let task = Task { try await container.networking.loadCurrencies() }
        await Task.yield()

        // Result
        XCTAssertTrue(container.sut.state == .loading)

        _ = try await task.value
        XCTAssertTrue(container.networking.isLoadCurrenciesCalled)

        let model = try modelContainer.mainContext.fetch(fetchDescriptor)
        XCTAssertNil(model.last)
    }

    private func mapCurrencyList(response: CurrencyListResponse) -> CurrencyListModel {
        let currencyModels = response.currenciesInfo.map {
            CurrencyModel(
                name: $0.name,
                code: $0.code,
                nativeSymbol: $0.symbolNative,
                decimalDigits: $0.decimalDigits
            )
        }
        .sorted(by: { $0.code < $1.code })

        return CurrencyListModel(currencies: currencyModels)
    }
}

extension XCTestCase {
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
}
